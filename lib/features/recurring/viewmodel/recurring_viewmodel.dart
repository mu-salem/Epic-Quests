import 'package:flutter/material.dart';
import '../../tasks/model/recurring_quest.dart';
import '../data/repository/sync_recurring_quest_repository.dart';

class RecurringViewModel extends ChangeNotifier {
  final SyncRecurringQuestRepository _repository;

  RecurringViewModel({required SyncRecurringQuestRepository repository})
    : _repository = repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<RecurringQuest> _quests = [];
  List<RecurringQuest> get quests => _quests;

  Future<void> loadQuests(String heroId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quests = await _repository.getForHero(heroId);
    } catch (e) {
      _error = 'Failed to load recurring quests: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveQuest(RecurringQuest quest) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Actually we need the save method in SyncRepository! We'll add that inside it!
      // Here doing a fake load for compile safety until we edit sync_recurring_quest_repository.dart
      await _repository.saveQuest(quest);
      await loadQuests(quest.heroId);
    } catch (e) {
      _error = 'Failed to save recurring quest: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleActive(String questId, String heroId) async {
    try {
      await _repository.toggleActive(questId);
      // Refresh locally updated state without heavy loading screen
      _quests = await _repository.getForHero(heroId);
      notifyListeners();
    } catch (e) {
      _error = 'Action failed: $e';
      notifyListeners();
    }
  }

  Future<void> deleteQuest(String questId, String heroId) async {
    try {
      await _repository.deleteRecurring(questId);
      _quests = await _repository.getForHero(heroId);
      notifyListeners();
    } catch (e) {
      _error = 'Delete failed: $e';
      notifyListeners();
    }
  }
}
