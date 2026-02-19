import 'package:flutter/foundation.dart';

import '../data/local/fake_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel for Login screen
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  LoginViewModel({AuthRepository? repository})
      : _repository = repository ?? FakeAuthRepository();

  // Form state
  String _email = '';
  String _password = '';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _showValidationErrors = false;

  // Validation errors
  String? _emailError;
  String? _passwordError;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get emailError => _showValidationErrors ? _emailError : null;
  String? get passwordError => _showValidationErrors ? _passwordError : null;
  bool get isValid => _email.isNotEmpty && _password.isNotEmpty && _emailError == null && _passwordError == null;

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
    _validateEmail();
    _validatePassword();

    if (_email.isEmpty) {
      _emailError = 'Email is required';
    }

    if (_password.isEmpty) {
      _passwordError = 'Password is required';
    }

    notifyListeners();
    return isValid;
  }

  /// Login user
  Future<bool> login() async {
    _clearMessages();

    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.login(_email, _password);

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
    _email = '';
    _password = '';
    _emailError = null;
    _passwordError = null;
    _showValidationErrors = false;
    _clearMessages();
    _isLoading = false;
    notifyListeners();
  }
}
