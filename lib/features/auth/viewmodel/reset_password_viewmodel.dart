import 'package:flutter/foundation.dart';

import '../data/remote/api_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel for Reset Password screen
class ResetPasswordViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final String email;
  final String code;

  ResetPasswordViewModel({
    required this.email,
    required this.code,
    AuthRepository? repository,
  }) : _repository = repository ?? ApiAuthRepository();

  // Form state
  String _password = '';
  String _confirmPassword = '';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _showValidationErrors = false;

  // Validation errors
  String? _passwordError;
  String? _confirmPasswordError;

  // Getters
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get passwordError => _showValidationErrors ? _passwordError : null;
  String? get confirmPasswordError =>
      _showValidationErrors ? _confirmPasswordError : null;
  bool get isValid =>
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty &&
      _passwordError == null &&
      _confirmPasswordError == null;

  /// Update password
  void updatePassword(String value) {
    _password = value;
    _validatePassword();
    _validateConfirmPassword();
    _clearMessages();
    notifyListeners();
  }

  /// Update confirm password
  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    _validateConfirmPassword();
    _clearMessages();
    notifyListeners();
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

  /// Validate confirm password
  void _validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = null;
      return;
    }

    if (_confirmPassword != _password) {
      _confirmPasswordError = 'Passwords do not match';
    } else {
      _confirmPasswordError = null;
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
    _validatePassword();
    _validateConfirmPassword();

    if (_password.isEmpty) {
      _passwordError = 'Password is required';
    }

    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirm password is required';
    }

    notifyListeners();
    return isValid;
  }

  /// Reset password
  Future<bool> resetPassword() async {
    _clearMessages();

    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.resetPassword(email, code, _password);

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
    _password = '';
    _confirmPassword = '';
    _passwordError = null;
    _confirmPasswordError = null;
    _showValidationErrors = false;
    _clearMessages();
    _isLoading = false;
    notifyListeners();
  }
}
