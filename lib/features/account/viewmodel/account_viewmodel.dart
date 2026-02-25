import 'package:flutter/foundation.dart';
import '../../auth/model/user_model.dart';
import '../data/repositories/account_repository.dart';
import '../data/remote/api_account_repository.dart';

class AccountViewModel extends ChangeNotifier {
  final AccountRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AccountViewModel({AccountRepository? repository})
    : _repository = repository ?? ApiAccountRepository();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch the user's profile from the backend
  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _user = await _repository.getProfile();
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// Update the user's display name
  Future<bool> updateProfile(String newName) async {
    if (newName.trim().isEmpty || _user == null) return false;
    if (newName.trim() == _user!.name) return true; // No change

    _setLoading(true);
    try {
      _user = await _repository.updateProfile(name: newName.trim());
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update the user's password
  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    try {
      await _repository.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
