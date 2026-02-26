import 'package:hive/hive.dart';
import '../../../core/services/xp_service.dart';
import 'quest.dart';

part 'hero_profile.g.dart';

@HiveType(typeId: 0)
class HeroProfile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatarAsset;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final int level;

  @HiveField(5)
  final int currentXP;

  @HiveField(6)
  final List<Quest> quests;

  @HiveField(7)
  final int currentStreak; // consecutive days with at least one completed quest

  @HiveField(8)
  final int longestStreak;

  @HiveField(9)
  final int totalCompletedQuests;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime? lastActivityDate;

  HeroProfile({
    required this.id,
    required this.name,
    required this.avatarAsset,
    required this.gender,
    this.level = 1,
    this.currentXP = 0,
    this.quests = const [],
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletedQuests = 0,
    DateTime? createdAt,
    this.lastActivityDate,
  }) : createdAt = createdAt ?? DateTime.now();

  int get maxXP => XPService.calculateMaxXP(level);

  static int calculateXPGain(QuestPriority priority) {
    return XPService.calculateXPGain(priority);
  }

  HeroProfile addXP(int xp) {
    final result = XPService.addXP(
      currentLevel: level,
      currentXP: currentXP,
      xpToAdd: xp,
    );
    return copyWith(level: result['level']!, currentXP: result['currentXP']!);
  }

  HeroProfile removeXP(int xp) {
    final result = XPService.removeXP(
      currentLevel: level,
      currentXP: currentXP,
      xpToRemove: xp,
    );
    return copyWith(level: result['level']!, currentXP: result['currentXP']!);
  }

  /// Update streak when a quest is completed
  HeroProfile recordQuestCompletion() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int newStreak = currentStreak;

    if (lastActivityDate != null) {
      final lastDay = DateTime(
        lastActivityDate!.year,
        lastActivityDate!.month,
        lastActivityDate!.day,
      );
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        // Same day, no streak change
      } else if (diff == 1) {
        // Consecutive day
        newStreak++;
      } else {
        // Streak broken
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    return copyWith(
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      totalCompletedQuests: totalCompletedQuests + 1,
      lastActivityDate: now,
    );
  }

  HeroProfile copyWith({
    String? id,
    String? name,
    String? avatarAsset,
    String? gender,
    int? level,
    int? currentXP,
    List<Quest>? quests,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletedQuests,
    DateTime? createdAt,
    DateTime? lastActivityDate,
  }) {
    return HeroProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      quests: quests ?? this.quests,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletedQuests: totalCompletedQuests ?? this.totalCompletedQuests,
      createdAt: createdAt ?? this.createdAt,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatarAsset,
      'gender': gender,
      'level': level,
      'xp': currentXP,
      'quests': quests.map((q) => q.toJson()).toList(),
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_completed_quests': totalCompletedQuests,
      'created_at': createdAt.toIso8601String(),
      'last_activity_date': lastActivityDate?.toIso8601String(),
    };
  }

  /// Strictly mapped payload for backend POST /heroes (Matches CreateHeroDto)
  Map<String, dynamic> toCreateJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatarAsset,
      'level': level,
      'xp': currentXP,
      'total_quests': quests.length,
      'completed_quests': totalCompletedQuests,
      'streak': currentStreak,
    };
  }

  /// Strictly mapped payload for backend PUT /heroes (Matches UpdateHeroDto)
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'level': level,
      'xp': currentXP,
      'completed_quests': totalCompletedQuests,
      'streak': currentStreak,
    };
  }

  factory HeroProfile.fromJson(Map<String, dynamic> json) {
    return HeroProfile(
      id: (json['id'] ?? json['_id']).toString(),
      name: json['name'] as String,
      avatarAsset: (json['avatarAsset'] ?? json['avatar']) as String,
      gender: json['gender'] as String? ?? 'male',
      level: json['level'] as int? ?? 1,
      currentXP: (json['currentXP'] ?? json['xp']) as int? ?? 0,
      quests:
          (json['quests'] as List<dynamic>?)
              ?.map((q) => Quest.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      currentStreak:
          (json['current_streak'] ?? json['currentStreak']) as int? ?? 0,
      longestStreak:
          (json['longest_streak'] ?? json['longestStreak']) as int? ?? 0,
      totalCompletedQuests:
          (json['total_completed_quests'] ?? json['totalCompletedQuests'])
              as int? ??
          0,
      createdAt: (json['created_at'] ?? json['createdAt']) != null
          ? DateTime.parse((json['created_at'] ?? json['createdAt']) as String)
          : DateTime.now(),
      lastActivityDate:
          (json['last_activity_date'] ?? json['lastActivityDate']) != null
          ? DateTime.parse(
              (json['last_activity_date'] ?? json['lastActivityDate'])
                  as String,
            )
          : null,
    );
  }
}
