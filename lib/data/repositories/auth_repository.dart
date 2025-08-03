import '../datasources/auth_data_source.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

/// Repository for authentication data operations
/// Coordinates between API and local storage
class AuthRepository {
  final AuthDataSource _authDataSource;
  final StorageService _storage;

  AuthRepository({
    required AuthDataSource authDataSource,
    required StorageService storage,
  })  : _authDataSource = authDataSource,
        _storage = storage;

  // MARK: - Data Retrieval

  /// Get stored tokens
  Future<AuthTokens?> getStoredTokens() async {
    try {
      final accessToken = await _storage.getString('accessToken');
      final refreshToken = await _storage.getString('refreshToken');
      
      if (accessToken != null && refreshToken != null) {
        return AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get stored user
  Future<User?> getStoredUser() async {
    try {
      return await _storage.getObject<User>(
        'user',
        User.fromJson,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get stored phone number
  Future<String?> getStoredPhoneNumber() async {
    try {
      return await _storage.getString('phoneNumber');
    } catch (e) {
      return null;
    }
  }

  
  // MARK: - Data Storage

  /// Save authentication data
Future<void> saveAuthData(AuthResponse authResponse) async {
  try {
    await Future.wait([ // From user
      _storage.saveString('accessToken', authResponse.accessToken),
      _storage.saveString('refreshToken', authResponse.refreshToken),
      _storage.saveObject('user', authResponse.user),
    ]);
  } catch (e) {
    // Handle storage errors
  }
}


  /// Clear all auth data
  Future<void> clearAllStorage() async {
    try {
      await _storage.clear();
    } catch (e) {
      // Handle storage errors
    }
  }

  // MARK: - API Operations

  /// Login with phone and PIN
  Future<ApiResponse<AuthResponse>> login(String phone, String pin) async {
    try {
      return await _authDataSource.login(phone, pin);
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
      return await _authDataSource.register(
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        pin: pin,
        phone: phone,
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  /// Get OTP for phone
  Future<ApiResponse<String>> getOtp(String phone) async {
    try {
      return await _authDataSource.getOtp(phone);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  /// Verify OTP
  Future<ApiResponse<String>> verifyOtp(String phone, String otp) async {
    try {
      return await _authDataSource.verifyOtp(phone, otp);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  /// Refresh access token
  Future<ApiResponse<AuthTokens>> refreshToken(String refreshToken) async {
    try {
      return await _authDataSource.refreshToken(refreshToken);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  /// Logout user
  Future<ApiResponse<String>> logout(String refreshToken, String accessToken) async {
    try {
      return await _authDataSource.logout(refreshToken, accessToken);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
} 