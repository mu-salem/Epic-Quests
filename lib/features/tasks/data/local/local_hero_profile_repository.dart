import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/preferences/local_storage_service.dart';
import '../../../../core/storage/hive/hive_service.dart';
import '../../../../core/storage/hive/hive_boxes.dart';
import '../../model/hero_profile.dart';
import '../repositories/hero_profile_repository.dart';

class LocalHeroProfileRepository implements HeroProfileRepository {
  /// Get the Hive box for hero profiles
  Box<HeroProfile> get _heroBox =>
      HiveService.getTypedBox<HeroProfile>(HiveBoxes.heroProfiles);

  @override
  Future<HeroProfile?> loadHeroProfile(String heroName) async {
    // heroName parameter can actually be heroId or heroName
    // Try to load by the provided key (works for both)
    debugPrint('📖 [LocalRepo] Attempting to load hero with key: $heroName');
    final hero = _heroBox.get(heroName);

    if (hero != null) {
      debugPrint('✅ [LocalRepo] Hero found: ${hero.name} (ID: ${hero.id})');
    } else {
      debugPrint('❌ [LocalRepo] No hero found with key: $heroName');
      debugPrint(
        '📊 [LocalRepo] Available keys in box: ${_heroBox.keys.toList()}',
      );
    }

    return hero;
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    debugPrint(
      '💾 [LocalRepo] Saving hero: ${profile.name} (ID: ${profile.id})',
    );
    debugPrint('💾 [LocalRepo] Using key: ${profile.id}');
    debugPrint('💾 [LocalRepo] Quests count: ${profile.quests.length}');

    // Use hero ID as key for easy retrieval
    await _heroBox.put(profile.id, profile);
    debugPrint('✅ [LocalRepo] Hero saved to Hive');

    // Verify save
    final saved = _heroBox.get(profile.id);
    if (saved != null) {
      debugPrint(
        '✅ [LocalRepo] Verification: Hero exists in Hive with ID: ${profile.id}',
      );
      debugPrint('✅ [LocalRepo] Verified quests count: ${saved.quests.length}');
    } else {
      debugPrint('❌ [LocalRepo] Verification FAILED: Hero NOT in Hive!');
    }

    return profile;
  }

  @override
  Future<void> deleteHeroProfile(String heroName) async {
    await _heroBox.delete(heroName);
  }

  @override
  Future<bool> hasHeroProfile(String heroName) async {
    return _heroBox.containsKey(heroName);
  }

  @override
  Future<String?> getLastSelectedHero() async {
    final heroId = LocalStorageService.getString(StorageKeys.lastSelectedHero);
    debugPrint('📌 [LocalRepo] Last selected hero: $heroId');
    return heroId;
  }

  @override
  Future<void> setLastSelectedHero(String heroName) async {
    debugPrint('📌 [LocalRepo] Setting last selected hero: $heroName');
    await LocalStorageService.setString(StorageKeys.lastSelectedHero, heroName);
    debugPrint('✅ [LocalRepo] Last selected hero saved');
  }

  @override
  Future<List<String>> listAllHeroes() async {
    final keys = _heroBox.keys.cast<String>().toList();
    debugPrint('📊 [LocalRepo] Total heroes in Hive: ${keys.length}');
    return keys;
  }
}
