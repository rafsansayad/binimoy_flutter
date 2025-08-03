import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  
  // Store current context and phone for flow
  AuthContext? _currentContext;
  String? _currentPhone;
  
  AuthBloc({required AuthRepository repository}) 
    : _repository = repository,
      super(const AuthState.initial()) {
    
    // App startup
    on<AppStarted>(_onAppStarted);
    
    // Phone and OTP flow
    on<SubmitPhone>(_onSubmitPhone);
    on<SubmitOtp>(_onSubmitOtp);
    
    // Profile creation
    on<CreateProfile>(_onCreateProfile);
    
    // KYC upload
    on<UploadKyc>(_onUploadKyc);
    
    // PIN input
    on<SubmitPin>(_onSubmitPin);
    
    // Session management
    on<Logout>(_onLogout);
    on<ClearError>(_onClearError);
  }
  
  // App startup - check session
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.initial());
    
    // Check for stored session
    final tokens = await _repository.getStoredTokens();
    final user = await _repository.getStoredUser();
    
    if (tokens != null && user != null) {
      // User has valid session - check if KYC is complete
      if (user.isKycVerified) {
        emit(AuthState.authenticated(response: AuthResponse(
          user: user,
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        )));
      } else {
        emit(const AuthState.kycRequired());
      }
    } else {
      // No session - show welcome
      emit(const AuthState.welcome());
    }
  }
  
  // Submit phone number and request OTP
  Future<void> _onSubmitPhone(SubmitPhone event, Emitter<AuthState> emit) async {
    _currentContext = event.context;
    _currentPhone = event.phone;
    
    emit(const AuthState.otpLoading());
    
    final result = await _repository.getOtp(event.phone);
    
    result.when(
      success: (data) => emit(const AuthState.otpInput()),
      error: (error) => emit(AuthState.error(message: error)),
    );
  }
  
  // Submit OTP and determine next step
  Future<void> _onSubmitOtp(SubmitOtp event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const AuthState.error(message: 'No phone number found'));
      return;
    }
    
    emit(const AuthState.otpVerifying());
    
    final result = await _repository.verifyOtp(_currentPhone!, event.otp);
    
    result.when(
      success: (data) {
        // OTP verified - determine next step based on context
        if (_currentContext == AuthContext.onboarding) {
          emit(const AuthState.profileCreation());
        } else {
          emit(const AuthState.pinInput());
        }
      },
      error: (error) => emit(AuthState.error(message: error)),
    );
  }
  
  // Create user profile
  Future<void> _onCreateProfile(CreateProfile event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const AuthState.error(message: 'No phone number found'));
      return;
    }
    
    emit(const AuthState.profileCreating());
    
    final result = await _repository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      userName: event.userName,
      pin: event.pin,
      phone: _currentPhone!,
    );
    
    result.when(
      success: (authResponse) async {
        // Save auth data
        await _repository.saveAuthData(authResponse);
        
        // Check if KYC is required
        if (authResponse.user.isKycVerified) {
          emit(AuthState.authenticated(response: authResponse));
        } else {
          emit(const AuthState.kycUpload());
        }
      },
      error: (error) => emit(AuthState.error(message: error)),
    );
  }
  
  // Upload KYC documents
  Future<void> _onUploadKyc(UploadKyc event, Emitter<AuthState> emit) async {
    emit(const AuthState.kycProcessing());
    
    // TODO: Implement KYC upload API
    // For now, simulate processing
    await Future.delayed(const Duration(seconds: 2));
    
    // Get current user and update KYC status
    final user = await _repository.getStoredUser();
    if (user != null) {
      // TODO: Update user with KYC verification
      emit(AuthState.authenticated(response: AuthResponse(
        user: user.copyWith(isKycVerified: true),
        accessToken: '', // Get from storage
        refreshToken: '', // Get from storage
      )));
    } else {
      emit(const AuthState.error(message: 'User not found'));
    }
  }
  
  // Submit PIN for login
  Future<void> _onSubmitPin(SubmitPin event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const AuthState.error(message: 'No phone number found'));
      return;
    }
    
    emit(const AuthState.pinVerifying());
    
    final result = await _repository.login(_currentPhone!, event.pin);
    
    result.when(
      success: (authResponse) async {
        // Save auth data
        await _repository.saveAuthData(authResponse);
        
        // Check if KYC is required
        if (authResponse.user.isKycVerified) {
          emit(AuthState.authenticated(response: authResponse));
        } else {
          emit(const AuthState.kycRequired());
        }
      },
      error: (error) => emit(AuthState.error(message: error)),
    );
  }
  
  // Logout user
  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    // Get stored tokens for API logout
    final tokens = await _repository.getStoredTokens();
    if (tokens != null) {
      try {
        await _repository.logout(tokens.refreshToken, tokens.accessToken);
      } catch (e) {
        // Ignore API logout errors
      }
    }
    
    // Clear local data
    await _repository.clearAllStorage();
    
    // Reset flow data
    _currentContext = null;
    _currentPhone = null;
    
    emit(const AuthState.welcome());
  }
  
  // Clear error and go back to welcome
  Future<void> _onClearError(ClearError event, Emitter<AuthState> emit) async {
    emit(const AuthState.welcome());
  }
}
