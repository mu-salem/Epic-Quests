import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:epicquests/features/tasks/model/recurring_quest.dart';
import 'package:epicquests/core/storage/hive/hive_boxes.dart';
import '../remote/api_recurring_quest_repository.dart';

class SyncRecurringQuestRepository {
  final ApiRecurringQuestRepository _apiRepository;

  SyncRecurringQuestRepository(this._apiRepository);

  /// Fetch quests offline, then try to sync online fetching
  Future<List<RecurringQuest>> getForHero(String heroId) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);

    // Attempt online sync first if possible, otherwise just use Hive
    try {
      final onlineQuests = await _apiRepository.getQuests(heroId);

      // Update Hive with online truth
      for (final q in onlineQuests) {
        await box.put(q.id, q);
      }
    } catch (e) {
      debugPrint(
        'SyncRecurringQuestRepository: Offline - using local data only',
      );
    }

    return box.values.where((r) => r.heroId == heroId).toList();
  }

  /// Save Quest
  Future<void> saveQuest(RecurringQuest quest) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    await box.put(quest.id, quest);

    try {
      await _apiRepository.createQuest(quest, quest.heroId);
    } catch (e) {
      debugPrint('SyncRecurringQuestRepository: Local save only ($e)');
    }
  }

  /// Delete Quest
  Future<void> deleteRecurring(String id) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    await box.delete(id);

    try {
      await _apiRepository.deleteQuest(id);
    } catch (e) {
      // Offline: Add an action queue later if needed. Assumes local delete overrides UI for now.
      // E.g. _actionQueueBox.add({...})
      debugPrint('SyncRecurringQuestRepository: Local delete only ($e)');
    }
  }

  /// Toggle Active
  Future<void> toggleActive(String id) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    final existing = box.get(id);
    if (existing != null) {
      final updated = existing.copyWith(isActive: !existing.isActive);
      await box.put(id, updated);

      try {
        await _apiRepository.updateQuest(updated);
      } catch (e) {
        debugPrint('SyncRecurringQuestRepository: Local toggle only ($e)');
      }
    }
  }
}
