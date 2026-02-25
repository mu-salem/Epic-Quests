import 'package:flutter/foundation.dart';
import '../../../features/tasks/data/repositories/sync_hero_profile_repository.dart';
import '../../../features/tasks/model/hero_profile.dart';
import '../../../features/tasks/model/quest.dart';

class CalendarViewModel extends ChangeNotifier {
  final SyncHeroProfileRepository _repository;

  List<HeroProfile> _heroes = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = false;

  final Map<DateTime, List<Quest>> _questEventsMap = {};

  CalendarViewModel({SyncHeroProfileRepository? repository})
    : _repository = repository ?? SyncHeroProfileRepository();

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    _heroes = await _repository.getAllHeroes();
    _buildEventsMap();
    _isLoading = false;
    notifyListeners();
  }

  void _buildEventsMap() {
    _questEventsMap.clear();
    for (final q in allQuests) {
      final d = q.deadline ?? q.createdAt;
      final dateKey = DateTime(d.year, d.month, d.day);
      if (_questEventsMap.containsKey(dateKey)) {
        _questEventsMap[dateKey]!.add(q);
      } else {
        _questEventsMap[dateKey] = [q];
      }
    }
  }

  List<Quest> get allQuests => _heroes.expand((h) => h.quests).toList();

  /// Quests due/created on a specific day
  List<Quest> questsForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _questEventsMap[dateKey] ?? [];
  }

  List<Quest> get selectedDayQuests => questsForDay(_selectedDay);

  /// Density 0-4 for heatmap coloring
  int densityForDay(DateTime day) {
    final count = questsForDay(day).length;
    if (count == 0) return 0;
    if (count <= 1) return 1;
    if (count <= 3) return 2;
    if (count <= 5) return 3;
    return 4;
  }

  /// Map of date to event list (for table_calendar)
  List<Quest> getEventsForDay(DateTime day) => questsForDay(day);

  void onDaySelected(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    notifyListeners();
  }

  void onPageChanged(DateTime focused) {
    _focusedDay = focused;
    notifyListeners();
  }
}
