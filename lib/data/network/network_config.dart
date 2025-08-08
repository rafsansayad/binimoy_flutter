import 'package:dio/dio.dart';

/// Network configuration for setting up Dio
/// Centralized place for all network-related setup
class NetworkConfig {
  static const String baseUrl = 'http://192.168.95.1:3000/api/v1';  //windows machine ip from android simulator
  static const Duration connectTimeout = Duration(seconds: 3);
  static const Duration receiveTimeout = Duration(seconds: 3);
  
  /// Create basic Dio instance with configuration
  static Dio createBasicDio() {
    final dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    return dio;
  }
} 