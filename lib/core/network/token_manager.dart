import '../constants/storage_keys.dart';
import '../storage/preferences/local_storage_service.dart';
import '../storage/secure/secure_storage_service.dart';

/// Manages authentication tokens and session
class TokenManager {
  /// Get access token from secure storage
  static Future<String?> getAccessToken() async {
    return await SecureStorageService.readSecure(StorageKeys.accessToken);
  }

  /// Get refresh token from secure storage
  static Future<String?> getRefreshToken() async {
    return await SecureStorageService.readSecure(StorageKeys.refreshToken);
  }

  /// Save new tokens (with rotation support)
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await SecureStorageService.writeSecure(
      StorageKeys.accessToken,
      accessToken,
    );

    if (refreshToken != null) {
      await SecureStorageService.writeSecure(
        StorageKeys.refreshToken,
        refreshToken,
      );
    }
  }

  /// Clear all authentication data
  static Future<void> clearAuthData() async {
    // Clear secure tokens
    await SecureStorageService.deleteSecure(StorageKeys.accessToken);
    await SecureStorageService.deleteSecure(StorageKeys.refreshToken);
    await SecureStorageService.deleteSecure(StorageKeys.userEmail);

    // Clear login flag
    await LocalStorageService.setBool('is_logged_in', false);
  }

  /// Check if user has valid tokens
  static Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null || refreshToken != null;
  }
}
