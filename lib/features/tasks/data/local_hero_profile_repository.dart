import '../../../core/constants/storage_keys.dart';
import '../../../core/services/local_storage_service.dart';
import '../model/hero_profile.dart';
import 'hero_profile_repository.dart';


class LocalHeroProfileRepository implements HeroProfileRepository {
  @override
  Future<HeroProfile?> loadHeroProfile(String heroName) async {
    final profileJson = LocalStorageService.getJson(StorageKeys.heroProfile(heroName));
    if (profileJson != null) {
      return HeroProfile.fromJson(profileJson);
    }
    return null;
  }

  @override
  Future<void> saveHeroProfile(HeroProfile profile) async {
    await LocalStorageService.setJson(
      StorageKeys.heroProfile(profile.name),
      profile.toJson(),
    );
  }

  @override
  Future<void> deleteHeroProfile(String heroName) async {
    await LocalStorageService.remove(StorageKeys.heroProfile(heroName));
  }

  @override
  Future<bool> hasHeroProfile(String heroName) async {
    final profileJson = LocalStorageService.getJson(StorageKeys.heroProfile(heroName));
    return profileJson != null;
  }

  @override
  Future<String?> getLastSelectedHero() async {
    return LocalStorageService.getString(StorageKeys.lastSelectedHero);
  }

  @override
  Future<void> setLastSelectedHero(String heroName) async {
    await LocalStorageService.setString(StorageKeys.lastSelectedHero, heroName);
  }

  @override
  Future<List<String>> listAllHeroes() async {
    // Get all keys from shared preferences
    final allKeys = LocalStorageService.getAllKeys();
    
    // Filter keys that start with "hero_" prefix
    final heroKeys = allKeys.where((key) => key.startsWith('hero_')).toList();
    
    // Extract hero names from keys (remove "hero_" prefix)
    final heroNames = heroKeys.map((key) => key.substring(5)).toList();
    
    return heroNames;
  }
}

