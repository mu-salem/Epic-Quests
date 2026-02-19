import 'package:flutter/foundation.dart';

import '../data/local/fake_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel for Forgot Password Code screen
class ForgotPasswordCodeViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final String email;

  ForgotPasswordCodeViewModel({
    required this.email,
    AuthRepository? repository,
  }) : _repository = repository ?? FakeAuthRepository();

  // Form state
  String _code = '';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _showValidationErrors = false;

  // Validation errors
  String? _codeError;

  // Getters
  String get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get codeError => _showValidationErrors ? _codeError : null;
  bool get isValid => _code.isNotEmpty && _codeError == null;

  /// Update code
  void updateCode(String value) {
    _code = value;
    _validateCode();
    _clearMessages();
    notifyListeners();
  }

  /// Validate code (must be 6 digits)
  void _validateCode() {
    if (_code.isEmpty) {
      _codeError = null;
      return;
    }

    final codeRegex = RegExp(r'^\d{6}$');
    if (!codeRegex.hasMatch(_code)) {
      _codeError = 'Code must be 6 digits';
    } else {
      _codeError = null;
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
    _validateCode();

    if (_code.isEmpty) {
      _codeError = 'Code is required';
    }

    notifyListeners();
    return isValid;
  }

  /// Verify reset code
  Future<bool> verifyCode() async {
    _clearMessages();

    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.verifyResetCode(email, _code);

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
    _code = '';
    _codeError = null;
    _showValidationErrors = false;
    _clearMessages();
    _isLoading = false;
    notifyListeners();
  }
}
