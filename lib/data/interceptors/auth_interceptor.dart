import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import '../datasources/auth_data_source.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../models/api_response.dart';

/// Auth interceptor/middleware for automatic token management and logging
/// Handles token injection, refresh, and basic request/response logging
class AuthInterceptor extends Interceptor {
  final StorageService _storage;
  final AuthDataSource _authDataSource;
  final AuthBloc _authBloc;

  AuthInterceptor({
    required StorageService storage,
    required AuthDataSource authDataSource,
    required AuthBloc authBloc,
  })  : _storage = storage,
        _authDataSource = authDataSource,
        _authBloc = authBloc;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Log outgoing request
    _logRequest(options);

    // Skip token for public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    // Add token to protected endpoints
    final accessToken = await _storage.getString('accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful response
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Log error
    _logError(err);

    // Handle 401 (Unauthorized) - token expired
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getString('refreshToken');
      if (refreshToken != null) {
        // Try to refresh token
        final result = await _authDataSource.refreshToken(refreshToken);
        
        result.when(
          success: (newTokens) async {
            // Save new tokens
            await Future.wait([
              _storage.saveString('accessToken', newTokens.accessToken),
              _storage.saveString('refreshToken', newTokens.refreshToken),
            ]);
            
            // Retry original request with new token
            err.requestOptions.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
            final response = await Dio().fetch(err.requestOptions);
            handler.resolve(response);
          },
          error: (error) async {
            // Refresh failed - clear session and notify BLoC
            await _storage.clear();
            _authBloc.add(const AuthEvent.logout());
            handler.next(err);
          },
        );
        return;
      }
    }
    
    handler.next(err);
  }

  /// Check if endpoint is public (doesn't need auth token)
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/get-otp',
      '/auth/verify-otp',
    ];
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Log outgoing request
  void _logRequest(RequestOptions options) {
    print('REQUEST: ${options.method.toUpperCase()} ${options.path}');
    if (options.data != null) {
      print('Data: ${options.data}');
    }
  }

  /// Log successful response
  void _logResponse(Response response) {
    print('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
  }

  /// Log error response
  void _logError(DioException err) {
    print('ERROR: ${err.response?.statusCode} ${err.requestOptions.path}');
    if (err.response?.data != null) {
      print('Error Data: ${err.response?.data}');
    }
  }
} 