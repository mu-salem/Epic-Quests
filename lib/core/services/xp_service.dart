import '../constants/xp_constants.dart';
import '../../features/tasks/model/quest.dart';

/// XP Service
///
/// Handles all XP and level calculations
class XPService {
  XPService._();

  /// Calculate max XP required for a given level
  static int calculateMaxXP(int level) {
    return XPConstants.xpPerLevel * level;
  }

  /// Calculate XP gain for completing a quest
  static int calculateXPGain(QuestPriority priority) {
    return XPConstants.xpRewards[priority] ??
        XPConstants.xpRewards[QuestPriority.medium]!;
  }

  /// Add XP and calculate new level and remaining XP
  /// Returns a map with 'level' and 'currentXP'
  static Map<String, int> addXP({
    required int currentLevel,
    required int currentXP,
    required int xpToAdd,
  }) {
    int newXP = currentXP + xpToAdd;
    int newLevel = currentLevel;

    // Handle level ups
    while (newXP >= calculateMaxXP(newLevel)) {
      newXP -= calculateMaxXP(newLevel);
      newLevel++;

      // Check if there's a max level
      if (XPConstants.maxLevel != null && newLevel > XPConstants.maxLevel!) {
        newLevel = XPConstants.maxLevel!;
        newXP = calculateMaxXP(newLevel); // Cap XP at max
        break;
      }
    }

    return {'level': newLevel, 'currentXP': newXP};
  }

  /// Remove XP and calculate new level and remaining XP
  /// Returns a map with 'level' and 'currentXP'
  static Map<String, int> removeXP({
    required int currentLevel,
    required int currentXP,
    required int xpToRemove,
  }) {
    int newXP = currentXP - xpToRemove;
    int newLevel = currentLevel;

    // Handle level downs (if XP becomes negative)
    while (newXP < 0 && newLevel > 1) {
      newLevel--;
      newXP += calculateMaxXP(newLevel);
    }

    // Prevent going below level 1 with 0 XP
    if (newLevel <= 1) {
      newLevel = 1;
      newXP = newXP < 0 ? 0 : newXP;
    }

    return {'level': newLevel, 'currentXP': newXP};
  }

  /// Calculate progress percentage (0.0 to 1.0)
  static double calculateProgress({
    required int currentXP,
    required int level,
  }) {
    final maxXP = calculateMaxXP(level);
    if (maxXP <= 0) return 0.0;
    return (currentXP / maxXP).clamp(0.0, 1.0);
  }
}
