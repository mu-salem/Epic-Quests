import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/avatar_item.dart';
import '../repositories/avatar_repository.dart';

/// Local implementation of AvatarRepository using SharedPreferences
class LocalAvatarRepository implements AvatarRepository {
  static const String _avatarsKey = 'user_avatars';

  @override
  Future<List<AvatarItem>> loadAvatars() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_avatarsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => AvatarItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AvatarItem>> loadAvatarsByGender(String gender) async {
    final avatars = await loadAvatars();
    return avatars.where((avatar) => avatar.gender == gender).toList();
  }

  @override
  Future<void> saveAvatar(AvatarItem avatar) async {
    final avatars = await loadAvatars();
    avatars.add(avatar);
    await _saveAvatars(avatars);
  }

  @override
  Future<void> updateAvatar(AvatarItem avatar) async {
    final avatars = await loadAvatars();
    final index = avatars.indexWhere((a) => a.id == avatar.id);

    if (index != -1) {
      avatars[index] = avatar;
      await _saveAvatars(avatars);
    }
  }

  @override
  Future<void> deleteAvatar(String avatarId) async {
    final avatars = await loadAvatars();
    avatars.removeWhere((avatar) => avatar.id == avatarId);
    await _saveAvatars(avatars);
  }

  @override
  Future<AvatarItem?> getAvatarById(String id) async {
    final avatars = await loadAvatars();
    try {
      return avatars.firstWhere((avatar) => avatar.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> hasAvatars() async {
    final avatars = await loadAvatars();
    return avatars.isNotEmpty;
  }

  /// Private helper to save avatars list
  Future<void> _saveAvatars(List<AvatarItem> avatars) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(avatars.map((a) => a.toJson()).toList());
    await prefs.setString(_avatarsKey, jsonString);
  }
}
