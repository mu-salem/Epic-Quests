import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../model/hero_profile.dart';
import '../repositories/hero_profile_repository.dart';

/// API-based Hero Profile Repository
/// Communicates with backend MongoDB database
class ApiHeroProfileRepository implements HeroProfileRepository {
  final ApiClient _apiClient;

  ApiHeroProfileRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<HeroProfile?> loadHeroProfile(String heroId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getHero(heroId));
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['hero'] != null) {
        return HeroProfile.fromJson(data['hero']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    // Check if hero exists
    final existingHero = await loadHeroProfile(profile.id);

    if (existingHero != null) {
      // Update existing hero
      final response = await _apiClient.put(
        ApiEndpoints.updateHero(profile.id),
        data: profile.toUpdateJson(),
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['success'] == true && data['hero'] != null) {
        return HeroProfile.fromJson(data['hero']);
      }
      return profile;
    }

    // Create new hero (POST)
    final response = await _apiClient.post(
      ApiEndpoints.createHero,
      data: profile.toCreateJson(),
    );

    final data = response.data as Map<String, dynamic>?;
    if (data != null && data['success'] == true && data['hero'] != null) {
      return HeroProfile.fromJson(data['hero']);
    }
    return profile;
  }

  @override
  Future<void> deleteHeroProfile(String heroId) async {
    await _apiClient.delete(ApiEndpoints.deleteHero(heroId));
  }

  @override
  Future<bool> hasHeroProfile(String heroId) async {
    final hero = await loadHeroProfile(heroId);
    return hero != null;
  }

  @override
  Future<String?> getLastSelectedHero() async {
    // Not stored on backend - return null
    // Last selected hero is a local preference
    return null;
  }

  @override
  Future<void> setLastSelectedHero(String heroName) async {
    // Not implemented - this is a local preference only
  }

  @override
  Future<List<String>> listAllHeroes() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getHeroes);
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['heroes'] != null) {
        final heroesList = data['heroes'] as List;
        return heroesList.map((json) => HeroProfile.fromJson(json).id).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get all hero profiles
  Future<List<HeroProfile>> getAllHeroes() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getHeroes);
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['heroes'] != null) {
        final heroesList = data['heroes'] as List;
        return heroesList.map((json) => HeroProfile.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Select a hero as active
  Future<void> selectHero(String heroId) async {
    await _apiClient.post(ApiEndpoints.selectHero(heroId));
  }

  /// Update hero XP and level
  Future<HeroProfile> updateHeroProgress({
    required String heroId,
    required int xpGain,
  }) async {
    // This would typically be done on the backend when completing a quest
    // Just fetch the updated hero profile
    final hero = await loadHeroProfile(heroId);
    if (hero == null) {
      throw Exception('Hero not found');
    }

    // Backend should handle XP and level calculations
    await saveHeroProfile(hero);
    return hero;
  }
}
