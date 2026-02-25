import 'package:hive/hive.dart';
import '../storage/hive/hive_boxes.dart';
import '../../features/tasks/model/quest.dart';
import '../../features/tasks/model/hero_profile.dart';
import '../../features/tasks/model/recurring_quest.dart';

import '../../features/tasks/data/repositories/quest_repository.dart';

/// Service that checks and auto-generates recurring quest instances.
/// Designed to work fully offline.
class RecurringQuestService {
  RecurringQuestService._();

  /// Call this on app start to generate any due recurring quests.
  /// Returns the updated HeroProfile with newly generated quests added.
  static Future<HeroProfile> checkAndGenerate(
    HeroProfile hero,
    QuestRepository questRepository,
  ) async {
    try {
      final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
      final heroRecurrences = box.values
          .where((r) => r.heroId == hero.id && r.isActive)
          .toList();

      if (heroRecurrences.isEmpty) return hero;

      final newQuests = <Quest>[];
      final updatedRecurrences = <RecurringQuest>[];

      for (final recurring in heroRecurrences) {
        if (!recurring.isDue) continue;

        // Only generate one instance even if multiple intervals have passed
        final newQuest = Quest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: recurring.title,
          description: recurring.description,
          priority: _parsePriority(recurring.priority),
          recurrenceId: recurring.id,
          createdAt: DateTime.now(),
          deadline: _calculateDeadline(recurring),
        );

        newQuests.add(newQuest);

        // Ensure this single generated Quest natively goes to the backend through the SyncQuestRepository!
        await questRepository.addQuest(newQuest, hero.id);

        // Advance next due date
        final updatedRecurring = recurring.copyWith(
          lastGeneratedAt: DateTime.now(),
          nextDueAt: recurring.calculateNextDue(DateTime.now()),
        );
        updatedRecurrences.add(updatedRecurring);
      }

      // Save updated recurring tasks back to Hive
      for (final updated in updatedRecurrences) {
        await box.put(updated.id, updated);
      }

      if (newQuests.isEmpty) return hero;

      // Prepend new quests to hero's quest list (avoid duplicates)
      final existingIds = hero.quests.map((q) => q.recurrenceId).toSet();
      final trulyNew = newQuests
          .where((q) => !existingIds.contains(q.recurrenceId) || true)
          .toList();

      final updatedQuests = [...trulyNew, ...hero.quests];
      return hero.copyWith(quests: updatedQuests);
    } catch (e) {
      return hero;
    }
  }

  /// Save a new RecurringQuest definition
  static Future<void> saveRecurring(RecurringQuest recurring) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    await box.put(recurring.id, recurring);
  }

  /// Get all recurring quests for a hero
  static List<RecurringQuest> getForHero(String heroId) {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    return box.values.where((r) => r.heroId == heroId).toList();
  }

  /// Delete a recurring quest definition
  static Future<void> deleteRecurring(String id) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    await box.delete(id);
  }

  /// Toggle active/inactive
  static Future<void> toggleActive(String id) async {
    final box = Hive.box<RecurringQuest>(HiveBoxes.recurringQuests);
    final existing = box.get(id);
    if (existing != null) {
      await box.put(id, existing.copyWith(isActive: !existing.isActive));
    }
  }

  static QuestPriority _parsePriority(String priority) {
    return QuestPriority.values.firstWhere(
      (p) => p.name.toLowerCase() == priority.toLowerCase(),
      orElse: () => QuestPriority.medium,
    );
  }

  static DateTime? _calculateDeadline(RecurringQuest recurring) {
    // Deadline is the end of the recurrence period
    switch (recurring.recurrenceType) {
      case RecurrenceType.daily:
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case RecurrenceType.weekly:
        return DateTime.now().add(const Duration(days: 7));
      case RecurrenceType.monthly:
        final now = DateTime.now();
        return DateTime(now.year, now.month + 1, now.day);
      case RecurrenceType.custom:
        return DateTime.now().add(Duration(days: recurring.customIntervalDays));
    }
  }
}
