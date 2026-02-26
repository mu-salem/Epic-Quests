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

    // Optimistically add to local state
    final isNew = !_quests.any((q) => q.id == quest.id);
    if (isNew) {
      _quests = [quest, ..._quests];
    } else {
      final index = _quests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _quests[index] = quest;
      }
    }
    _isLoading = false;
    notifyListeners();

    // Background sync
    _repository
        .saveQuest(quest)
        .then((_) {
          _repository.getForHero(quest.heroId).then((syncedQuests) {
            _quests = syncedQuests;
            notifyListeners();
          });
        })
        .catchError((e) {
          _error = 'Failed to save recurring quest: $e';
          notifyListeners();
        });
  }

  Future<void> toggleActive(String questId, String heroId) async {
    // Optimistic Update
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index != -1) {
      final quest = _quests[index];
      _quests[index] = quest.copyWith(isActive: !quest.isActive);
      notifyListeners();
    }

    _repository
        .toggleActive(questId)
        .then((_) {
          // Background full refresh
          _repository.getForHero(heroId).then((syncedQuests) {
            _quests = syncedQuests;
            notifyListeners();
          });
        })
        .catchError((e) {
          _error = 'Action failed: $e';
          notifyListeners();
        });
  }

  Future<void> deleteQuest(String questId, String heroId) async {
    // Optimistic Update
    _quests.removeWhere((q) => q.id == questId);
    notifyListeners();

    _repository
        .deleteRecurring(questId)
        .then((_) {
          // Background full refresh
          _repository.getForHero(heroId).then((syncedQuests) {
            _quests = syncedQuests;
            notifyListeners();
          });
        })
        .catchError((e) {
          _error = 'Delete failed: $e';
          notifyListeners();
        });
  }
}
