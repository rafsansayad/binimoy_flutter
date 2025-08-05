import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  
  // Store phone, user, tokens in memory
  String? _currentPhone;
  AuthResponse? _currentAuthResponse; 
  
  AuthBloc({required AuthRepository repository}) 
    : _repository = repository,
      super(const AuthState.initial()) {
    
    // App startup
    on<AppStartedEvent>(_onAppStarted);
    
    // Phone and OTP flow
    on<SubmitPhoneEvent>(_onSubmitPhone);
    on<SubmitOtpEvent>(_onSubmitOtp);
    
    // Profile creation
    on<CreateProfileEvent>(_onCreateProfile);
    
    // KYC upload
    on<UploadKycEvent>(_onUploadKyc);
    
    // PIN input
    on<SubmitPinEvent>(_onSubmitPin);
    
    // Session management
    on<LogoutEvent>(_onLogout);
    on<ClearErrorEvent>(_onClearError);
  }
  
  // App startup - check session
  Future<void> _onAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(const InitialState());
    
    // Check for stored session
    final tokens = await _repository.getStoredTokens();
    final user = await _repository.getStoredUser();
    
    if (tokens != null && user != null) {
      // User has valid session - go to main app
      emit(AuthenticatedState(response: AuthResponse(
        user: user,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      )));
    } else {
      // No session - show welcome
      emit(const WelcomeState());
    }
  }
  
  // Submit phone number and request OTP
  Future<void> _onSubmitPhone(SubmitPhoneEvent event, Emitter<AuthState> emit) async {
    _currentPhone = event.phone;
    
    emit(const OtpLoadingState());
    
    final result = await _repository.getOtp(event.phone);
    
    result.when(
      success: (data) => emit(OtpInputState(context: event.context)),
      error: (error) => emit(ErrorState(message: error)),
    );
  }
  
  // Submit OTP and determine next step
  Future<void> _onSubmitOtp(SubmitOtpEvent event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const ErrorState(message: 'No phone number found'));
      return;
    }
    
    emit(OtpVerifyingState(context: event.context));
    
    final result = await _repository.verifyOtp(_currentPhone!, event.otp);
    
    result.when(
      success: (data) {
        // OTP verified - determine next step based on context
        if (event.context == AuthContext.onboarding) {
          emit(const ProfileCreationState());
        } else {
          emit(const PinInputState());
        }
      },
      error: (error) => emit(ErrorState(message: error)),
    );
  }
  
  // Create user profile
  Future<void> _onCreateProfile(CreateProfileEvent event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const ErrorState(message: 'No phone number found'));
      return;
    }
    
    emit(const ProfileCreatingState());
    
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
        _currentAuthResponse = authResponse; // Store in memory
        
        // New users need KYC
        emit(const KycUploadState());
      },
      error: (error) => emit(ErrorState(message: error)),
    );
  }
  
  // Upload KYC documents
  Future<void> _onUploadKyc(UploadKycEvent event, Emitter<AuthState> emit) async {
    emit(const KycProcessingState());
    
    // TODO: Implement KYC upload API
    // Use stored data directly
    if (_currentAuthResponse != null) {
      emit(AuthenticatedState(response: _currentAuthResponse!));
    }
  }
  
  // Submit PIN for login
  Future<void> _onSubmitPin(SubmitPinEvent event, Emitter<AuthState> emit) async {
    if (_currentPhone == null) {
      emit(const ErrorState(message: 'No phone number found'));
      return;
    }
    
    emit(const PinVerifyingState());
    
    final result = await _repository.login(_currentPhone!, event.pin);
    
    result.when(
      success: (authResponse) async {
        // Save auth data
        await _repository.saveAuthData(authResponse);
        _currentAuthResponse = authResponse; // Store in memory
  
          emit(AuthenticatedState(response: authResponse));

      },
      error: (error) => emit(ErrorState(message: error)),
    );
  }
  
  // Logout user
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // Get stored tokens for API logout
    final tokens = await _repository.getStoredTokens();
    if (tokens != null) {
      try {
        await _repository.logout(tokens.refreshToken, tokens.accessToken);
      } catch (e) {
        // Log error for debugging, but don't fail logout
        print('Logout API failed: $e');
      }
    }
    
    // Clear local data
    await _repository.clearAllStorage();
    
    // Reset flow data
    _currentPhone = null;
    _currentAuthResponse = null; // Clear memory cache
    
    emit(const WelcomeState());
  }
  
  // Clear error and go back to welcome
  Future<void> _onClearError(ClearErrorEvent event, Emitter<AuthState> emit) async {
    emit(const WelcomeState());
  }
}
