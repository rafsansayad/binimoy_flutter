import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

enum AuthContext { onboarding, login }

@freezed
class AuthEvent with _$AuthEvent {
  // App startup
  const factory AuthEvent.appStarted() = AppStartedEvent;
  
  // Phone and OTP flow
  const factory AuthEvent.submitPhone({
    required String phone,
    required AuthContext context,
  }) = SubmitPhoneEvent;
  
  const factory AuthEvent.submitOtp({
    required String otp,
    required AuthContext context,
  }) = SubmitOtpEvent;
  
  // Profile creation
  const factory AuthEvent.createProfile({
    required String firstName,
    required String lastName,
    required String userName,
    required String pin,
  }) = CreateProfileEvent;
  
  // KYC upload
  const factory AuthEvent.uploadKyc({
    required String nidImage,
    required String selfieImage,
  }) = UploadKycEvent;
  
  // PIN input
  const factory AuthEvent.submitPin({
    required String pin,
  }) = SubmitPinEvent;
  
  // Session management
  const factory AuthEvent.logout() = LogoutEvent;
  
  // Error handling
  const factory AuthEvent.clearError() = ClearErrorEvent;
} 