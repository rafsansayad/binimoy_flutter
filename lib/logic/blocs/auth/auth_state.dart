import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/models.dart';
import 'auth_event.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  // App startup
  const factory AuthState.initial() = Initial;
  const factory AuthState.welcome() = Welcome;
  
  // Phone and OTP flow
  const factory AuthState.phoneInput({
    required AuthContext context,
  }) = PhoneInput;
  
  const factory AuthState.otpLoading() = OtpLoading;
  const factory AuthState.otpInput() = OtpInput;
  const factory AuthState.otpVerifying() = OtpVerifying;
  
  // Profile creation
  const factory AuthState.profileCreation() = ProfileCreation;
  const factory AuthState.profileCreating() = ProfileCreating;
  
  // KYC upload
  const factory AuthState.kycUpload() = KycUpload;
  const factory AuthState.kycProcessing() = KycProcessing;
  
  // PIN input
  const factory AuthState.pinInput() = PinInput;
  const factory AuthState.pinVerifying() = PinVerifying;
  
  // Success states
  const factory AuthState.authenticated({
    required AuthResponse response,
  }) = Authenticated;
  
  const factory AuthState.kycRequired() = KycRequired;
  
  // Error state
  const factory AuthState.error({
    required String message,
  }) = Error;
} 