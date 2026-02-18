import '../../../core/services/xp_service.dart';
import 'quest.dart';

/// Hero Profile Model
/// 
/// Represents a hero (avatar) with their progress, stats, and quests
class HeroProfile {
  final String name;
  final String avatarAsset;
  final String gender; // 'boy' or 'girl'
  final int level;
  final int currentXP;
  final List<Quest> quests;

  HeroProfile({
    required this.name,
    required this.avatarAsset,
    required this.gender,
    this.level = 1,
    this.currentXP = 0,
    this.quests = const [],
  });

  /// Calculate XP needed for current level
  int get maxXP => XPService.calculateMaxXP(level);

  /// Calculate XP gain based on quest priority
  static int calculateXPGain(QuestPriority priority) {
    return XPService.calculateXPGain(priority);
  }

  /// Add XP and handle level up
  HeroProfile addXP(int xp) {
    final result = XPService.addXP(
      currentLevel: level,
      currentXP: currentXP,
      xpToAdd: xp,
    );

    return copyWith(
      level: result['level']!,
      currentXP: result['currentXP']!,
    );
  }

  /// Remove XP from hero (delegates to XPService)
  HeroProfile removeXP(int xp) {
    final result = XPService.removeXP(
      currentLevel: level,
      currentXP: currentXP,
      xpToRemove: xp,
    );

    return copyWith(
      level: result['level']!,
      currentXP: result['currentXP']!,
    );
  }

  /// Copy with method
  HeroProfile copyWith({
    String? name,
    String? avatarAsset,
    String? gender,
    int? level,
    int? currentXP,
    List<Quest>? quests,
  }) {
    return HeroProfile(
      name: name ?? this.name,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      quests: quests ?? this.quests,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarAsset': avatarAsset,
      'gender': gender,
      'level': level,
      'currentXP': currentXP,
      'quests': quests.map((q) => q.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory HeroProfile.fromJson(Map<String, dynamic> json) {
    return HeroProfile(
      name: json['name'] as String,
      avatarAsset: json['avatarAsset'] as String,
      gender: json['gender'] as String,
      level: json['level'] as int? ?? 1,
      currentXP: json['currentXP'] as int? ?? 0,
      quests: (json['quests'] as List<dynamic>?)
              ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
