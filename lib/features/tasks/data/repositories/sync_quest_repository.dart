import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/sync/sync_service.dart';
import '../../model/quest.dart';
import '../local/local_quest_repository.dart';
import '../remote/api_quest_repository.dart';
import '../repositories/quest_repository.dart';

class SyncQuestRepository implements QuestRepository {
  final LocalQuestRepository _localRepository;
  final ApiQuestRepository _apiRepository;
  final ConnectivityService _connectivityService;
  final SyncService _syncService;

  SyncQuestRepository({
    LocalQuestRepository? localRepository,
    ApiQuestRepository? apiRepository,
    ConnectivityService? connectivityService,
    SyncService? syncService,
  }) : _localRepository = localRepository ?? LocalQuestRepository(),
       _apiRepository = apiRepository ?? ApiQuestRepository(),
       _connectivityService = connectivityService ?? ConnectivityService(),
       _syncService = syncService ?? SyncService();

  /// Check if device is online
  bool get _isOnline => _connectivityService.isOnline;

  @override
  Future<List<Quest>> getQuests() async {
    // Always return from local cache for instant load
    final localQuests = await _localRepository.getQuests();

    // If online, sync with API in background
    if (_isOnline) {
      _syncQuestsInBackground();
    }

    return localQuests;
  }

  @override
  Future<Quest> addQuest(Quest quest, String heroId) async {
    if (_isOnline) {
      try {
        final syncedQuest = await _apiRepository.addQuest(quest, heroId);

        // If ID changed (e.g. from local timestamp to Mongo ObjectID), delete the old one
        if (quest.id != syncedQuest.id) {
          await _localRepository.deleteQuest(quest.id);
        }

        await _localRepository.addQuest(syncedQuest, heroId);
        return syncedQuest;
      } catch (e) {
        // Fall back to local save and queue if API fails
      }
    }

    // Offline/Fallback - saving locally and queueing
    await _localRepository.addQuest(quest, heroId);
    await _syncService.addPendingAction(
      endpoint: '/quests',
      method: 'POST',
      data: quest.toCreateJson(heroId),
      localId: quest.id,
    );
    return quest;
  }

  @override
  Future<void> updateQuest(Quest quest) async {
    // Update local storage immediately
    await _localRepository.updateQuest(quest);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.updateQuest(quest);
      } catch (e) {
        // If API call fails, queue for later sync
        await _syncService.addPendingAction(
          endpoint: '/quests/${quest.id}',
          method: 'PATCH',
          data: quest.toUpdateJson(),
          localId: quest.id,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/quests/${quest.id}',
        method: 'PATCH',
        data: quest.toUpdateJson(),
        localId: quest.id,
      );
    }
  }

  @override
  Future<void> deleteQuest(String questId) async {
    // Delete from local storage immediately
    await _localRepository.deleteQuest(questId);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.deleteQuest(questId);
      } catch (e) {
        // If API call fails, queue for later sync
        await _syncService.addPendingAction(
          endpoint: '/quests/$questId',
          method: 'DELETE',
          localId: questId,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/quests/$questId',
        method: 'DELETE',
        localId: questId,
      );
    }
  }

  @override
  Future<void> saveQuests(List<Quest> quests) async {
    // Save all quests to local storage
    await _localRepository.saveQuests(quests);
  }

  /// Sync quests from API in background
  Future<void> _syncQuestsInBackground() async {
    try {
      final apiQuests = await _apiRepository.getQuests();
      await _localRepository.saveQuests(apiQuests);
    } catch (e) {
      // Silently fail - local cache is still valid
      // Could log error here
    }
  }

  /// Force sync with API (pull latest data)
  Future<void> syncFromApi() async {
    if (!_isOnline) {
      throw Exception('Cannot sync while offline');
    }

    final apiQuests = await _apiRepository.getQuests();
    await _localRepository.saveQuests(apiQuests);
  }

  /// Complete a quest
  Future<void> completeQuest(String questId) async {
    // Update local quest
    final quests = await _localRepository.getQuests();
    final quest = quests.firstWhere((q) => q.id == questId);
    final completedQuest = quest.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    await _localRepository.updateQuest(completedQuest);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.completeQuest(questId);
      } catch (e) {
        // Queue for sync
        await _syncService.addPendingAction(
          endpoint: '/quests/$questId/complete',
          method: 'PATCH',
          localId: questId,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/quests/$questId/complete',
        method: 'PATCH',
        localId: questId,
      );
    }
  }

  /// Uncomplete a quest
  Future<void> uncompleteQuest(String questId) async {
    // Update local quest
    final quests = await _localRepository.getQuests();
    final quest = quests.firstWhere((q) => q.id == questId);
    final uncompletedQuest = quest.copyWith(
      isCompleted: false,
      completedAt: null,
    );
    await _localRepository.updateQuest(uncompletedQuest);

    // Sync with API
    if (_isOnline) {
      try {
        await _apiRepository.uncompleteQuest(questId);
      } catch (e) {
        // Queue for sync
        await _syncService.addPendingAction(
          endpoint: '/quests/$questId/uncomplete',
          method: 'PATCH',
          localId: questId,
        );
      }
    } else {
      // Queue for sync when back online
      await _syncService.addPendingAction(
        endpoint: '/quests/$questId/uncomplete',
        method: 'PATCH',
        localId: questId,
      );
    }
  }

  /// Get quests by status (active or completed)
  Future<List<Quest>> getQuestsByStatus(bool isCompleted) async {
    final allQuests = await getQuests();
    return allQuests.where((q) => q.isCompleted == isCompleted).toList();
  }

  /// Get quests by priority
  Future<List<Quest>> getQuestsByPriority(QuestPriority priority) async {
    final allQuests = await getQuests();
    return allQuests.where((q) => q.priority == priority).toList();
  }

  /// Get pending sync actions count
  Future<int> getPendingSyncCount() async {
    return await _syncService.getPendingActionsCount();
  }
}
