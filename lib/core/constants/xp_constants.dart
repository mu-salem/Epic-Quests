import '../../features/tasks/model/quest.dart';

/// XP System Constants
/// 
/// Defines all XP-related constants for the leveling system
class XPConstants {
  XPConstants._();
  
  /// XP multiplier per level (Level 1 = 100 XP, Level 2 = 200 XP, etc.)
  static const int xpPerLevel = 100;
  
  /// XP rewards based on quest priority
  static const Map<QuestPriority, int> xpRewards = {
    QuestPriority.low: 10,
    QuestPriority.medium: 25,
    QuestPriority.high: 50,
  };
  
  /// Starting level for new heroes
  static const int startingLevel = 1;
  
  /// Starting XP for new heroes
  static const int startingXP = 0;
  
  /// Maximum level (optional, can be removed if there's no cap)
  static const int? maxLevel = null; // No level cap
}
