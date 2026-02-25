import 'package:flutter/foundation.dart';

import '../data/remote/api_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel for Register screen
class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  RegisterViewModel({AuthRepository? repository})
    : _repository = repository ?? ApiAuthRepository();

  // Form state
  String _username = '';
  String _email = '';
  String _password = '';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _showValidationErrors = false;

  // Validation errors
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Getters
  String get username => _username;
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get usernameError => _showValidationErrors ? _usernameError : null;
  String? get emailError => _showValidationErrors ? _emailError : null;
  String? get passwordError => _showValidationErrors ? _passwordError : null;
  String? get confirmPasswordError =>
      _showValidationErrors ? _confirmPasswordError : null;

  bool get userExistsError =>
      _errorMessage != null &&
      (_errorMessage!.toLowerCase().contains('already exists') ||
          _errorMessage!.toLowerCase().contains('duplicate'));

  bool get isValid =>
      _username.isNotEmpty &&
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _usernameError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null;

  /// Update username
  void updateUsername(String value) {
    _username = value;
    _validateUsername();
    _clearMessages();
    notifyListeners();
  }

  /// Update email
  void updateEmail(String value) {
    _email = value;
    _validateEmail();
    _clearMessages();
    notifyListeners();
  }

  /// Update password
  void updatePassword(String value) {
    _password = value;
    _validatePassword();
    _clearMessages();
    notifyListeners();
  }

  /// Validate username
  void _validateUsername() {
    if (_username.isEmpty) {
      _usernameError = null;
      return;
    }

    if (_username.length < 3) {
      _usernameError = 'Username must be at least 3 characters';
    } else if (_username.length > 20) {
      _usernameError = 'Username must be less than 20 characters';
    } else {
      _usernameError = null;
    }
  }

  /// Validate email format
  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = null;
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_email)) {
      _emailError = 'Invalid email format';
    } else {
      _emailError = null;
    }
  }

  /// Validate password
  void _validatePassword() {
    if (_password.isEmpty) {
      _passwordError = null;
      return;
    }

    if (_password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
    } else {
      _passwordError = null;
    }
  }

  /// Clear error and success messages
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Validate all fields
  bool validate() {
    _showValidationErrors = true;
    _validateUsername();
    _validateEmail();
    _validatePassword();

    if (_username.isEmpty) {
      _usernameError = 'Username is required';
    }

    if (_email.isEmpty) {
      _emailError = 'Email is required';
    }

    if (_password.isEmpty) {
      _passwordError = 'Password is required';
    }

    notifyListeners();
    return isValid;
  }

  /// Register user
  Future<bool> register() async {
    _clearMessages();

    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.register(_username, _email, _password);

      _isLoading = false;

      if (result.success) {
        _successMessage = result.message;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Spell failed. Try again.';
      notifyListeners();
      return false;
    }
  }

  /// Clear all form data
  void clear() {
    _username = '';
    _email = '';
    _password = '';
    _usernameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _showValidationErrors = false;
    _clearMessages();
    _isLoading = false;
    notifyListeners();
  }
}
