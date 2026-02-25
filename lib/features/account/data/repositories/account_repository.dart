import '../../../auth/model/user_model.dart';

abstract class AccountRepository {
  /// Fetches the current user's profile
  Future<UserModel> getProfile();

  /// Updates the user's name
  Future<UserModel> updateProfile({required String name});

  /// Updates the user's password
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
