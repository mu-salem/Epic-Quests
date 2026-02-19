import 'package:flutter/foundation.dart';

import '../data/local/fake_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel for Forgot Password Email screen
class ForgotPasswordEmailViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  ForgotPasswordEmailViewModel({AuthRepository? repository})
      : _repository = repository ?? FakeAuthRepository();

  // Form state
  String _email = '';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _showValidationErrors = false;

  // Validation errors
  String? _emailError;

  // Getters
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get emailError => _showValidationErrors ? _emailError : null;
  bool get isValid => _email.isNotEmpty && _emailError == null;

  /// Update email
  void updateEmail(String value) {
    _email = value;
    _validateEmail();
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

  /// Clear error and success messages
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Validate all fields
  bool validate() {
    _showValidationErrors = true;
    _validateEmail();

    if (_email.isEmpty) {
      _emailError = 'Email is required';
    }

    notifyListeners();
    return isValid;
  }

  /// Send reset code
  Future<bool> sendResetCode() async {
    _clearMessages();

    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.sendResetCode(_email);

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
    _emailError = null;
    _showValidationErrors = false;
    _clearMessages();
    _isLoading = false;
    notifyListeners();
  }
}
