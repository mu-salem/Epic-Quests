import '../../model/auth_result.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResult> login(String email, String password);

  /// Register a new user
  Future<AuthResult> register(String email, String password);

  /// Send password reset code to email
  Future<AuthResult> sendResetCode(String email);

  /// Verify password reset code
  Future<AuthResult> verifyResetCode(String email, String code);

  /// Reset password with verified code
  Future<AuthResult> resetPassword(String email, String code, String newPassword);

  /// Logout current user
  Future<void> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get current user token
  Future<String?> getToken();
}
