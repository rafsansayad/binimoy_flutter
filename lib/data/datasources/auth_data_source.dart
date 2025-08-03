import 'package:dio/dio.dart';
import '../models/models.dart';

class AuthDataSource {
  final Dio _dio;
  
  AuthDataSource({required Dio dio}) : _dio = dio;
  
  
  
  /// Request OTP for phone number
  Future<ApiResponse<String>> getOtp(String phone) async {
    try {
      final response = await _dio.post('/auth/get-otp', data: {
        'phone': phone,
      });
      
      return ApiResponse.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
  
  /// Verify OTP and create server side session
  Future<ApiResponse<String>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
      });
      
      return ApiResponse.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  Future<ApiResponse<AuthResponse>> login(String phone, String pin) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'pin': pin,
      });
      
      return ApiResponse.success(
        data: AuthResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
  
  /// Register new user
  Future<ApiResponse<AuthResponse>> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String pin,
    required String phone,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'pin': pin,
        'phone': phone,
      });
      
      return ApiResponse.success(
        data: AuthResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
  
  /// Logout user
  Future<ApiResponse<String>> logout(String refreshToken, String accessToken) async {
    try {
      final response = await _dio.post('/auth/logout', data: {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      });
      
      return ApiResponse.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
  
  /// Refresh access token
  Future<ApiResponse<AuthTokens>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh-access-token', data: {
        'refreshToken': refreshToken,
      });
      
      return ApiResponse.success(
        data: AuthTokens.fromJson(response.data),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
} 