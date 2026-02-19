import 'user_model.dart';

class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;

  AuthResult({
    required this.success,
    this.message,
    this.user,
    this.token,
  });

  factory AuthResult.success({
    required UserModel user,
    required String token,
    String? message,
  }) {
    return AuthResult(
      success: true,
      user: user,
      token: token,
      message: message ?? 'Success',
    );
  }

  factory AuthResult.failure({required String message}) {
    return AuthResult(
      success: false,
      message: message,
    );
  }
}
