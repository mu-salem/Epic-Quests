import 'package:hive/hive.dart';

part 'pomodoro_session.g.dart';

@HiveType(typeId: 7)
class PomodoroSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? questId; // optional link to quest

  @HiveField(2)
  final String heroId;

  @HiveField(3)
  final DateTime startedAt;

  @HiveField(4)
  final DateTime endedAt;

  @HiveField(5)
  final int workDurationMinutes;

  @HiveField(6)
  final bool wasCompleted; // false if user interrupted

  @HiveField(7)
  final int xpAwarded;

  PomodoroSession({
    required this.id,
    this.questId,
    required this.heroId,
    required this.startedAt,
    required this.endedAt,
    required this.workDurationMinutes,
    this.wasCompleted = true,
    this.xpAwarded = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quest_id': questId,
      'hero_id': heroId,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt.toIso8601String(),
      'work_duration_minutes': workDurationMinutes,
      'was_completed': wasCompleted,
      'xp_awarded': xpAwarded,
    };
  }
}
