import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

enum AuthContext { onboarding, login }

@freezed
class AuthEvent with _$AuthEvent {
  // App startup
  const factory AuthEvent.appStarted() = AppStarted;
  
  // Phone and OTP flow
  const factory AuthEvent.submitPhone({
    required String phone,
    required AuthContext context,
  }) = SubmitPhone;
  
  const factory AuthEvent.submitOtp({
    required String otp,
  }) = SubmitOtp;
  
  // Profile creation
  const factory AuthEvent.createProfile({
    required String firstName,
    required String lastName,
    required String userName,
    required String pin,
  }) = CreateProfile;
  
  // KYC upload
  const factory AuthEvent.uploadKyc({
    required String nidImage,
    required String selfieImage,
  }) = UploadKyc;
  
  // PIN input
  const factory AuthEvent.submitPin({
    required String pin,
  }) = SubmitPin;
  
  // Session management
  const factory AuthEvent.logout() = Logout;
  
  // Error handling
  const factory AuthEvent.clearError() = ClearError;
} 