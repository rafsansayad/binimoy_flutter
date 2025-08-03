import 'package:dio/dio.dart';
import '../datasources/auth_data_source.dart';
import '../services/storage_service.dart';
import '../interceptors/interceptors.dart';
import '../../logic/blocs/auth/auth_bloc.dart';

/// Network configuration for setting up Dio with interceptors
/// Centralized place for all network-related setup
class NetworkConfig {
  static const String _baseUrl = 'http://127.0.0.1:3000/api/v1';
  
  /// Create and configure Dio instance
  static Dio createDio({
    required StorageService storage,
    required AuthBloc authBloc,
  }) {
    final dio = Dio();
    
    // Set base URL
    dio.options.baseUrl = _baseUrl;
    
    // Set default timeout
    dio.options.connectTimeout = const Duration(seconds: 3);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    
    // Create auth data source for interceptor
    final authDataSource = AuthDataSource(dio: dio);
    
    // Create and add auth interceptor
    final authInterceptor = AuthInterceptor(
      storage: storage,
      authDataSource: authDataSource,
      authBloc: authBloc,
    );
    
    dio.interceptors.add(authInterceptor);
    
    return dio;
  }
  
  /// Create configured AuthDataSource instance 
  static AuthDataSource createAuthDataSource({
    required StorageService storage,
    required AuthBloc authBloc,
  }) {
    final dio = createDio(storage: storage, authBloc: authBloc);
    return AuthDataSource(dio: dio);
  }
} 