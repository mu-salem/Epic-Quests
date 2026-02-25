import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Write a secure value
  static Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure value
  static Future<String?> readSecure(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a secure value
  static Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all secure storage
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  /// Read all keys
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
