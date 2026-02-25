import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/remote/api_auth_repository.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  VerifyEmailViewModel({AuthRepository? repository})
    : _repository = repository ?? ApiAuthRepository();

  String _email = '';
  String _code = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  String get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String email) {
    _email = email;
    _errorMessage = null;
    notifyListeners();
  }

  void updateCode(String value) {
    _code = value;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> verifyEmail() async {
    if (_email.isEmpty || _code.length < 6) {
      _errorMessage = 'Please enter the full 6-digit code';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.verifyEmail(_email, _code);

      _isLoading = false;

      if (result.success) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred during verification';
      notifyListeners();
      return false;
    }
  }
}
