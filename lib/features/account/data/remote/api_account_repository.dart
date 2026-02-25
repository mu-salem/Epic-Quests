import '../../../../core/network/api_client.dart';
import '../../../../core/network/error_handling/api_exception.dart';
import '../../../auth/model/user_model.dart';
import '../repositories/account_repository.dart';

class ApiAccountRepository implements AccountRepository {
  final ApiClient _apiClient;

  ApiAccountRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get('/users/profile');
      final data = response.data;

      if (data == null || data['success'] != true || data['user'] == null) {
        throw ApiException('Invalid response from server');
      }

      return UserModel.fromJson(data['user']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch user profile.');
    }
  }

  @override
  Future<UserModel> updateProfile({required String name}) async {
    try {
      final response = await _apiClient.patch(
        '/users/profile',
        data: {'name': name},
      );
      final data = response.data;

      if (data == null || data['success'] != true || data['user'] == null) {
        throw ApiException(data?['message'] ?? 'Failed to update profile');
      }

      return UserModel.fromJson(data['user']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'An unexpected error occurred while updating profile.',
      );
    }
  }

  @override
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/users/update-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      final data = response.data;
      if (data == null || data['success'] != true) {
        throw ApiException(data?['message'] ?? 'Failed to update password');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'An unexpected error occurred while updating password.',
      );
    }
  }
}
