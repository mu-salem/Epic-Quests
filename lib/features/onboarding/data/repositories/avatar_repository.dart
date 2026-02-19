import '../../model/avatar_item.dart';

/// Repository interface for Avatar operations
abstract class AvatarRepository {
  /// Load all user avatars
  Future<List<AvatarItem>> loadAvatars();

  /// Load avatars by gender
  Future<List<AvatarItem>> loadAvatarsByGender(String gender);

  /// Save a new avatar
  Future<void> saveAvatar(AvatarItem avatar);

  /// Update an existing avatar
  Future<void> updateAvatar(AvatarItem avatar);

  /// Delete an avatar
  Future<void> deleteAvatar(String avatarId);

  /// Get avatar by id
  Future<AvatarItem?> getAvatarById(String id);

  /// Check if any avatars exist
  Future<bool> hasAvatars();
}
