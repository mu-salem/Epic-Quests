import '../../model/hero_profile.dart';

/// Repository for managing multiple hero profiles
abstract class HeroProfileRepository {
  /// Load a specific hero profile by name
  Future<HeroProfile?> loadHeroProfile(String heroName);

  /// Save a hero profile
  Future<HeroProfile> saveHeroProfile(HeroProfile profile);

  /// Delete a specific hero profile
  Future<void> deleteHeroProfile(String heroName);

  /// Check if a specific hero profile exists
  Future<bool> hasHeroProfile(String heroName);

  /// Get the name of the last selected hero
  Future<String?> getLastSelectedHero();

  /// Set the last selected hero name
  Future<void> setLastSelectedHero(String heroName);

  /// List all hero names that have profiles
  Future<List<String>> listAllHeroes();
}
