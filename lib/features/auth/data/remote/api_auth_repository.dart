import '../../../../core/network/api_client.dart';
import '../../../../core/network/error_handling/api_exception.dart';
import '../../../../core/storage/preferences/local_storage_service.dart';
import '../../model/auth_result.dart';
import '../../model/user_model.dart';
import '../repositories/auth_repository.dart';
import '../local/secure_auth_storage.dart';

/// Real API implementation of AuthRepository using Dio
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final SecureAuthStorage _secureStorage = SecureAuthStorage();

  static const String _isLoggedInKey = 'is_logged_in';

  ApiAuthRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      // Clear any existing tokens before login
      await _secureStorage.clearTokens();
      await LocalStorageService.setBool(_isLoggedInKey, false);

      final response = await _apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      // Parse response
      final data = response.data;

      if (data == null) {
        return AuthResult.failure(message: 'No response from server');
      }

      if (data['success'] == true) {
        // Validate required fields exist
        if (data['user'] == null) {
          return AuthResult.failure(
            message: 'Invalid response: user data missing',
          );
        }
        if (data['tokens'] == null || data['tokens']['access_token'] == null) {
          return AuthResult.failure(message: 'Invalid response: token missing');
        }

        final user = UserModel.fromJson(data['user']);
        final token = data['tokens']['access_token'] as String;
        final refreshToken = data['tokens']['refresh_token'] as String?;

        // Save tokens to secure storage
        await _secureStorage.saveTokens(
          accessToken: token,
          refreshToken: refreshToken,
        );
        await _secureStorage.saveUserEmail(email);
        await LocalStorageService.setBool(_isLoggedInKey, true);

        return AuthResult.success(
          user: user,
          token: token,
          message: data['message'] ?? 'Quest Accepted! Welcome back, hero!',
        );
      }

      return AuthResult.failure(message: data['message'] ?? 'Login failed');
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } on ArgumentError catch (e) {
      return AuthResult.failure(
        message: 'Invalid server response: ${e.message}',
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      // Clear any existing tokens before register
      await _secureStorage.clearTokens();
      await LocalStorageService.setBool(_isLoggedInKey, false);

      final response = await _apiClient.post(
        '/auth/register',
        // Node backend expects 'name', not 'username'
        data: {'name': username, 'email': email, 'password': password},
      );

      // Parse response
      final data = response.data;

      if (data == null) {
        return AuthResult.failure(message: 'No response from server');
      }

      if (data['success'] == true) {
        // Since Email Verification is required now, registration does not return user/token!
        // We just return success and a temporary structure so the UI knows to move forward.
        return AuthResult.success(
          user: UserModel(id: 'temp', email: email, createdAt: DateTime.now()),
          token: '',
          message:
              data['message'] ?? 'Registration successful. Check your email.',
        );
      }

      return AuthResult.failure(
        message: data['message'] ?? 'Registration failed',
      );
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } on ArgumentError catch (e) {
      return AuthResult.failure(
        message: 'Invalid server response: ${e.message}',
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> verifyEmail(String email, String code) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-email',
        data: {'email': email, 'code': code},
      );

      final data = response.data;

      if (data['success'] == true) {
        return AuthResult.success(
          user: UserModel(id: 'temp', email: email, createdAt: DateTime.now()),
          token: '',
          message:
              data['message'] ??
              'Email verified successfully! You may now login.',
        );
      }

      return AuthResult.failure(
        message: data['message'] ?? 'Failed to verify email',
      );
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> sendResetCode(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      final data = response.data;

      if (data['success'] == true) {
        return AuthResult.success(
          user: UserModel(id: 'temp', email: email, createdAt: DateTime.now()),
          token: '',
          message: data['message'] ?? 'Magic code sent! Check your scroll.',
        );
      }

      return AuthResult.failure(
        message: data['message'] ?? 'Failed to send reset code',
      );
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> verifyResetCode(String email, String code) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-reset-code',
        data: {'email': email, 'code': code},
      );

      final data = response.data;

      if (data['success'] == true) {
        return AuthResult.success(
          user: UserModel(id: 'temp', email: email, createdAt: DateTime.now()),
          token: '',
          message: data['message'] ?? 'Code verified! Proceed to reset.',
        );
      }

      return AuthResult.failure(message: data['message'] ?? 'Invalid code');
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: {'email': email, 'code': code, 'new_password': newPassword},
      );

      final data = response.data;

      if (data['success'] == true) {
        return AuthResult.success(
          user: UserModel(id: 'temp', email: email, createdAt: DateTime.now()),
          token: '',
          message: data['message'] ?? 'Password reset! You may now login.',
        );
      }

      return AuthResult.failure(
        message: data['message'] ?? 'Password reset failed',
      );
    } on ApiException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint to invalidate token on server
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Always clear local data
      await _secureStorage.clearTokens();
      await LocalStorageService.setBool(_isLoggedInKey, false);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final hasFlag = LocalStorageService.getBool(_isLoggedInKey) ?? false;
    final hasToken = await _secureStorage.hasToken();
    return hasFlag && hasToken;
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.getAccessToken();
  }
}
