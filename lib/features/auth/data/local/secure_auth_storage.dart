import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/secure/secure_storage_service.dart';

class SecureAuthStorage {
  /// Save authentication tokens securely
  Future<void> saveTokens({
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

  /// Get access token
  Future<String?> getAccessToken() async {
    return await SecureStorageService.readSecure(StorageKeys.accessToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await SecureStorageService.readSecure(StorageKeys.refreshToken);
  }

  /// Save user email securely (optional, can be used for auto-fill)
  Future<void> saveUserEmail(String email) async {
    await SecureStorageService.writeSecure(StorageKeys.userEmail, email);
  }

  /// Get saved user email
  Future<String?> getUserEmail() async {
    return await SecureStorageService.readSecure(StorageKeys.userEmail);
  }

  /// Clear all auth tokens
  Future<void> clearTokens() async {
    await SecureStorageService.deleteSecure(StorageKeys.accessToken);
    await SecureStorageService.deleteSecure(StorageKeys.refreshToken);
    await SecureStorageService.deleteSecure(StorageKeys.userEmail);
  }

  /// Check if user has valid token (doesn't validate expiry, just checks existence)
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
