import '../../../../core/services/local_storage_service.dart';
import '../../model/auth_result.dart';
import '../../model/user_model.dart';
import '../repositories/auth_repository.dart';

/// Fake implementation of AuthRepository for testing without real API
class FakeAuthRepository implements AuthRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _resetCodeKey = 'reset_code_';

  // Simulated network delay
  static const Duration _networkDelay = Duration(seconds: 1);

  // Fake user database (for demo)
  final Map<String, String> _fakeUsers = {
    'test@epicquests.com': 'password123',
  };

  @override
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(_networkDelay);

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure(message: 'Email and password are required');
    }

    // Check if user exists and password matches
    if (_fakeUsers.containsKey(email) && _fakeUsers[email] == password) {
      final user = UserModel(
        id: 'user_${email.hashCode}',
        email: email,
        name: email.split('@')[0],
        createdAt: DateTime.now(),
      );

      final token = 'fake_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

      // Save to local storage
      await LocalStorageService.setString(_tokenKey, token);
      await LocalStorageService.setString(_userEmailKey, email);
      await LocalStorageService.setBool(_isLoggedInKey, true);

      return AuthResult.success(
        user: user,
        token: token,
        message: 'Quest Accepted! Welcome back, hero!',
      );
    }

    return AuthResult.failure(message: 'Invalid credentials. Try again, adventurer.');
  }

  @override
  Future<AuthResult> register(String email, String password) async {
    await Future.delayed(_networkDelay);

    // Validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure(message: 'Email and password are required');
    }

    if (_fakeUsers.containsKey(email)) {
      return AuthResult.failure(message: 'This hero already exists!');
    }

    // Register new user
    _fakeUsers[email] = password;

    final user = UserModel(
      id: 'user_${email.hashCode}',
      email: email,
      name: email.split('@')[0],
      createdAt: DateTime.now(),
    );

    final token = 'fake_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

    // Save to local storage
    await LocalStorageService.setString(_tokenKey, token);
    await LocalStorageService.setString(_userEmailKey, email);
    await LocalStorageService.setBool(_isLoggedInKey, true);

    return AuthResult.success(
      user: user,
      token: token,
      message: 'Portal Opened! Your journey begins!',
    );
  }

  @override
  Future<AuthResult> sendResetCode(String email) async {
    await Future.delayed(_networkDelay);

    if (email.isEmpty) {
      return AuthResult.failure(message: 'Email is required');
    }

    if (!_fakeUsers.containsKey(email)) {
      return AuthResult.failure(message: 'No hero found with this email');
    }

    // Generate fake 6-digit code
    final code = '123456'; // In real app, this would be random
    await LocalStorageService.setString('$_resetCodeKey$email', code);

    return AuthResult.success(
      user: UserModel(
        id: 'temp',
        email: email,
        createdAt: DateTime.now(),
      ),
      token: '',
      message: 'Magic code sent! Check your scroll.',
    );
  }

  @override
  Future<AuthResult> verifyResetCode(String email, String code) async {
    await Future.delayed(_networkDelay);

    if (email.isEmpty || code.isEmpty) {
      return AuthResult.failure(message: 'Email and code are required');
    }

    final savedCode = LocalStorageService.getString('$_resetCodeKey$email');

    if (savedCode == null) {
      return AuthResult.failure(message: 'No code found. Request a new one.');
    }

    if (savedCode != code) {
      return AuthResult.failure(message: 'Invalid code. Try again.');
    }

    return AuthResult.success(
      user: UserModel(
        id: 'temp',
        email: email,
        createdAt: DateTime.now(),
      ),
      token: '',
      message: 'Code verified! Proceed to reset.',
    );
  }

  @override
  Future<AuthResult> resetPassword(String email, String code, String newPassword) async {
    await Future.delayed(_networkDelay);

    // Verify code first
    final verifyResult = await verifyResetCode(email, code);
    if (!verifyResult.success) {
      return verifyResult;
    }

    if (newPassword.isEmpty || newPassword.length < 8) {
      return AuthResult.failure(message: 'Password must be at least 8 characters');
    }

    // Update password in fake database
    _fakeUsers[email] = newPassword;

    // Clear reset code
    await LocalStorageService.remove('$_resetCodeKey$email');

    return AuthResult.success(
      user: UserModel(
        id: 'temp',
        email: email,
        createdAt: DateTime.now(),
      ),
      token: '',
      message: 'Password reset! You may now login.',
    );
  }

  @override
  Future<void> logout() async {
    await LocalStorageService.remove(_tokenKey);
    await LocalStorageService.remove(_userEmailKey);
    await LocalStorageService.setBool(_isLoggedInKey, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return LocalStorageService.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<String?> getToken() async {
    return LocalStorageService.getString(_tokenKey);
  }
}
