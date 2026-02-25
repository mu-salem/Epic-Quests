/// Defines constants for quest cleanup behavior
class QuestCleanupConstants {
  QuestCleanupConstants._();

  /// Number of days to keep completed quests before auto-deletion
  static const int daysToKeepCompletedQuests = 1;

  /// Whether to auto-cleanup on app start
  static const bool autoCleanupOnStart = true;
}
