import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../features/tasks/data/repositories/sync_hero_profile_repository.dart';
import '../../../features/tasks/model/hero_profile.dart';
import '../../../features/tasks/model/quest.dart';

class StatsViewModel extends ChangeNotifier {
  final SyncHeroProfileRepository _repository;

  List<HeroProfile> _heroes = [];
  HeroProfile? _currentHero;
  bool _isLoading = false;

  StatsViewModel({SyncHeroProfileRepository? repository})
    : _repository = repository ?? SyncHeroProfileRepository();

  bool get isLoading => _isLoading;
  List<HeroProfile> get heroes => _heroes;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _heroes = await _repository.getAllHeroes();

    // Determine the active hero
    try {
      final userBox = await Hive.openBox('epic_quests_user');
      final lastHeroId = userBox.get('last_selected_hero_id');
      if (lastHeroId != null) {
        _currentHero = _heroes.where((h) => h.id == lastHeroId).firstOrNull;
      }
    } catch (e) {
      debugPrint('Error getting last selected hero in stats: $e');
    }

    // Fallback to first hero if none explicitly selected
    if (_currentHero == null && _heroes.isNotEmpty) {
      _currentHero = _heroes.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Quest> get allQuests => _currentHero?.quests ?? [];

  int get totalCompleted => allQuests.where((q) => q.isCompleted).length;

  int get totalActive => allQuests.where((q) => !q.isCompleted).length;

  double get completionRate {
    final total = allQuests.length;
    if (total == 0) return 0;
    return totalCompleted / total;
  }

  Duration? get averageCompletionTime {
    final completed = allQuests
        .where((q) => q.isCompleted && q.completionDuration != null)
        .toList();
    if (completed.isEmpty) return null;
    final totalMs = completed.fold<int>(
      0,
      (sum, q) => sum + q.completionDuration!.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ completed.length);
  }

  // Priority distribution
  Map<QuestPriority, int> get priorityDistribution {
    final dist = <QuestPriority, int>{
      QuestPriority.low: 0,
      QuestPriority.medium: 0,
      QuestPriority.high: 0,
    };
    for (final q in allQuests.where((q) => q.isCompleted)) {
      dist[q.priority] = (dist[q.priority] ?? 0) + 1;
    }
    return dist;
  }

  // Completed quests by day (last 7 days)
  List<DailyCount> get last7DaysCounts {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      final count = allQuests.where((q) {
        if (!q.isCompleted || q.completedAt == null) return false;
        final d = q.completedAt!;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      }).length;
      return DailyCount(date: day, count: count);
    });
  }

  // Completed quests this month
  int get completedThisMonth {
    final now = DateTime.now();
    return allQuests.where((q) {
      if (!q.isCompleted || q.completedAt == null) return false;
      return q.completedAt!.year == now.year &&
          q.completedAt!.month == now.month;
    }).length;
  }

  // Completed quests this week
  int get completedThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return allQuests.where((q) {
      if (!q.isCompleted || q.completedAt == null) return false;
      return q.completedAt!.isAfter(weekDay);
    }).length;
  }
}

class DailyCount {
  final DateTime date;
  final int count;
  const DailyCount({required this.date, required this.count});
}
