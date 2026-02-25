import '../constants/quest_cleanup_constants.dart';
import '../../features/tasks/model/quest.dart';

/// Quest Cleanup Service
///
/// Handles automatic cleanup of expired quests
class QuestCleanupService {
  QuestCleanupService._();

  /// Filter out expired completed quests
  /// Returns a new list with only valid quests
  static List<Quest> removeExpiredQuests(List<Quest> quests) {
    final now = DateTime.now();

    return quests.where((quest) {
      // Keep all active quests
      if (!quest.isCompleted) return true;

      // Check if completed quest has expired
      if (quest.completedAt != null) {
        final daysSinceCompletion = now.difference(quest.completedAt!).inDays;
        return daysSinceCompletion <
            QuestCleanupConstants.daysToKeepCompletedQuests;
      }

      // Remove completed quests without completedAt timestamp (old data)
      return false;
    }).toList();
  }

  /// Check if any quests need to be cleaned up
  static bool needsCleanup(List<Quest> quests) {
    final cleanedQuests = removeExpiredQuests(quests);
    return cleanedQuests.length != quests.length;
  }

  /// Count how many quests will be removed
  static int countExpiredQuests(List<Quest> quests) {
    final cleanedQuests = removeExpiredQuests(quests);
    return quests.length - cleanedQuests.length;
  }
}
