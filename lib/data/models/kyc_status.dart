import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_status.freezed.dart';
part 'kyc_status.g.dart';

enum KycStatus {
  @JsonValue('submitted')
  submitted,
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
}

@freezed
class KycStatusResponse with _$KycStatusResponse {
  const factory KycStatusResponse({
    required KycStatus status,
  }) = _KycStatusResponse;

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) => _$KycStatusResponseFromJson(json);
} 