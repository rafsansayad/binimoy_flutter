import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveObject<T>(String key, T object);
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> hasKey(String key);
}

/// Secure storage implementation using flutter_secure_storage
class SecureStorageService implements StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );



  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw StorageException('Failed to save string: $key', e);
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw StorageException('Failed to read string: $key', e);
    }
  }

  @override
  Future<void> saveObject<T>(String key, T object) async {
    try {
      final jsonString = jsonEncode(object);
      await _storage.write(key: key, value: jsonString);
    } catch (e) {
      throw StorageException('Failed to save object: $key', e);
    }
  }

  @override
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final jsonString = await _storage.read(key: key);
      if (jsonString == null) return null;
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      throw StorageException('Failed to read object: $key', e);
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw StorageException('Failed to delete: $key', e);
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException('Failed to clear storage', e);
    }
  }

  @override
  Future<bool> hasKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      throw StorageException('Failed to check key: $key', e);
    }
  }


}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;
  final dynamic originalError;

  StorageException(this.message, this.originalError);

  @override
  String toString() => 'StorageException: $message\nOriginal error: $originalError';
} 