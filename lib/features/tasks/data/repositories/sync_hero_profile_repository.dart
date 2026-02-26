import 'package:flutter/foundation.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/sync/sync_service.dart';
import '../../model/hero_profile.dart';
import '../local/local_hero_profile_repository.dart';
import '../remote/api_hero_profile_repository.dart';
import '../repositories/hero_profile_repository.dart';

class SyncHeroProfileRepository implements HeroProfileRepository {
  final LocalHeroProfileRepository _localRepository;
  final ApiHeroProfileRepository _apiRepository;
  final ConnectivityService _connectivityService;
  final SyncService _syncService;

  SyncHeroProfileRepository({
    LocalHeroProfileRepository? localRepository,
    ApiHeroProfileRepository? apiRepository,
    ConnectivityService? connectivityService,
    SyncService? syncService,
  }) : _localRepository = localRepository ?? LocalHeroProfileRepository(),
       _apiRepository = apiRepository ?? ApiHeroProfileRepository(),
       _connectivityService = connectivityService ?? ConnectivityService(),
       _syncService = syncService ?? SyncService();

  /// Check if device is online
  bool get _isOnline => _connectivityService.isOnline;

  @override
  Future<HeroProfile?> loadHeroProfile(String heroId) async {
    // Always return from local cache for instant load
    final localHero = await _localRepository.loadHeroProfile(heroId);

    // If online, sync with API in background
    if (_isOnline) {
      _syncHeroInBackground(heroId);
    }

    return localHero;
  }

  @override
  Future<HeroProfile> saveHeroProfile(HeroProfile profile) async {
    debugPrint('🔄 [Sync] Saving hero profile: ${profile.name}');

    if (_isOnline) {
      debugPrint('🌐 [Sync] Online - syncing to API first...');
      try {
        final syncedProfile = await _apiRepository.saveHeroProfile(profile);
        debugPrint('✅ [Sync] Synced to API, got ID: ${syncedProfile.id}');

        // If ID changed (e.g. from local timestamp to Mongo ObjectID), delete the old one
        if (profile.id != syncedProfile.id) {
          debugPrint(
            '🧹 [Sync] Cleaning up old local timestamp ID: ${profile.id}',
          );
          await _localRepository.deleteHeroProfile(profile.id);
        }

        debugPrint('💾 [Sync] Saving to local repository...');
        await _localRepository.saveHeroProfile(syncedProfile);
        debugPrint('✅ [Sync] Saved to local');
        return syncedProfile;
      } catch (e) {
        debugPrint('❌ [Sync] API sync failed: $e, falling back to local');
        // Fall back to local save and queue if API fails
      }
    }

    debugPrint('📴 [Sync] Offline/Fallback - saving locally and queueing...');
    await _localRepository.saveHeroProfile(profile);
    await _syncService.addPendingAction(
      endpoint: '/heroes/${profile.id}',
      method: 'PUT',
      data: profile.toJson(),
      localId: profile.id,
    );
    return profile;
  }

  @override
  Future<void> deleteHeroProfile(String heroId) async {
    // Delete from local storage immediately
    await _localRepository.deleteHeroProfile(heroId);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.deleteHeroProfile(heroId);
      } catch (e) {
        // If API call fails, queue for later sync
        await _syncService.addPendingAction(
          endpoint: '/heroes/$heroId',
          method: 'DELETE',
          localId: heroId,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/heroes/$heroId',
        method: 'DELETE',
        localId: heroId,
      );
    }
  }

  @override
  Future<bool> hasHeroProfile(String heroId) async {
    // Check local storage
    return await _localRepository.hasHeroProfile(heroId);
  }

  @override
  Future<String?> getLastSelectedHero() async {
    // This is always local - never synced with API
    return await _localRepository.getLastSelectedHero();
  }

  @override
  Future<void> setLastSelectedHero(String heroName) async {
    // This is always local - never synced with API
    await _localRepository.setLastSelectedHero(heroName);
  }

  @override
  Future<List<String>> listAllHeroes() async {
    // Always return from local cache for instant load
    final localHeroes = await _localRepository.listAllHeroes();

    // If online, sync with API in background
    if (_isOnline) {
      _syncHeroesInBackground();
    }

    return localHeroes;
  }

  /// Sync a specific hero from API in background
  Future<void> _syncHeroInBackground(String heroId) async {
    try {
      final apiHero = await _apiRepository.loadHeroProfile(heroId);
      if (apiHero != null) {
        await _localRepository.saveHeroProfile(apiHero);
      }
    } catch (e) {
      // Silently fail - local cache is still valid
    }
  }

  /// Sync all heroes from API in background
  Future<void> _syncHeroesInBackground() async {
    try {
      final apiHeroes = await _apiRepository.getAllHeroes();
      for (final hero in apiHeroes) {
        await _localRepository.saveHeroProfile(hero);
      }
    } catch (e) {
      // Silently fail - local cache is still valid
    }
  }

  /// Force sync with API (pull latest data)
  Future<void> syncFromApi() async {
    if (!_isOnline) {
      throw Exception('Cannot sync while offline');
    }

    final apiHeroes = await _apiRepository.getAllHeroes();
    for (final hero in apiHeroes) {
      await _localRepository.saveHeroProfile(hero);
    }
  }

  /// Get all hero profiles
  Future<List<HeroProfile>> getAllHeroes() async {
    final heroIds = await listAllHeroes();
    final heroes = <HeroProfile>[];

    for (final heroId in heroIds) {
      final hero = await loadHeroProfile(heroId);
      if (hero != null) {
        heroes.add(hero);
      }
    }

    return heroes;
  }

  /// Select a hero as active
  Future<void> selectHero(String heroId) async {
    // Update local preference
    await setLastSelectedHero(heroId);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.selectHero(heroId);
      } catch (e) {
        // Queue for sync
        await _syncService.addPendingAction(
          endpoint: '/heroes/$heroId/select',
          method: 'POST',
          localId: heroId,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/heroes/$heroId/select',
        method: 'POST',
        localId: heroId,
      );
    }
  }

  /// Create new hero profile
  Future<HeroProfile> createHero(HeroProfile profile) async {
    return await saveHeroProfile(profile);
  }

  /// Get pending sync actions count
  Future<int> getPendingSyncCount() async {
    return await _syncService.getPendingActionsCount();
  }
}
