import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/models.dart';
import 'auth_event.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState { 
  // App startup
  const factory AuthState.initial() = InitialState;
  const factory AuthState.welcome() = WelcomeState;
  
  // Phone and OTP flow
  const factory AuthState.phoneInput({
    required AuthContext context,
  }) = PhoneInputState;
  
  const factory AuthState.otpLoading() = OtpLoadingState;
  const factory AuthState.otpInput({
    required AuthContext context,
  }) = OtpInputState;
  const factory AuthState.otpVerifying({
    required AuthContext context,
  }) = OtpVerifyingState;
  
  // Profile creation
  const factory AuthState.profileCreation() = ProfileCreationState;
  const factory AuthState.profileCreating() = ProfileCreatingState;
  
  // KYC upload
  const factory AuthState.kycUpload() = KycUploadState;
  const factory AuthState.kycProcessing() = KycProcessingState;
  
  // PIN input
  const factory AuthState.pinInput() = PinInputState;
  const factory AuthState.pinVerifying() = PinVerifyingState;
  
  // Success states
  const factory AuthState.authenticated({
    required AuthResponse response,
  }) = AuthenticatedState;
  
  const factory AuthState.kycRequired() = KycRequiredState;
  
  // Error state
  const factory AuthState.error({
    required String message,
  }) = ErrorState;
} 