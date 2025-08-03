import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required T data,
  }) = ApiResponseSuccess<T>;

  const factory ApiResponse.error({
    required String error,
  }) = ApiResponseError<T>;
} 