import 'package:flutter/foundation.dart';

import '../../../core/resources/app_images.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/quest_cleanup_service.dart';
import '../../../core/services/recurring_quest_service.dart';
import '../data/repositories/hero_profile_repository.dart';
import '../data/repositories/sync_hero_profile_repository.dart';
import '../model/hero_profile.dart';
import '../model/quest.dart';
import '../model/recurring_quest.dart';
import '../data/repositories/quest_repository.dart';
import '../data/repositories/sync_quest_repository.dart';

class TasksViewModel extends ChangeNotifier {
  // Dependencies
  final HeroProfileRepository _repository;
  final QuestRepository _questRepository;

  // Current Hero
  String? _currentHeroName;

  // Hero Profile
  HeroProfile? _heroProfile;

  // Search & Filter State
  String _searchQuery = '';
  QuestPriority? _selectedPriority;

  // Cached Filtered Lists
  List<Quest>? _cachedFilteredActiveQuests;
  List<Quest>? _cachedFilteredCompletedQuests;

  void _invalidateCache() {
    _cachedFilteredActiveQuests = null;
    _cachedFilteredCompletedQuests = null;
  }

  // Constructor with dependency injection
  TasksViewModel({
    HeroProfileRepository? repository,
    QuestRepository? questRepository,
  }) : _repository = repository ?? SyncHeroProfileRepository(),
       _questRepository = questRepository ?? SyncQuestRepository();

  // Getters
  String? get currentHeroName => _currentHeroName;
  HeroProfile? get heroProfile => _heroProfile;
  String get searchQuery => _searchQuery;
  QuestPriority? get selectedPriority => _selectedPriority;
  List<Quest> get allQuests => _heroProfile?.quests ?? [];

  // Hero stats getters
  String get heroName => _heroProfile?.name ?? 'Hero';
  String get avatarAsset =>
      _heroProfile?.avatarAsset ?? AppImages.defaultAvatar;
  int get level => _heroProfile?.level ?? 1;
  int get currentXP => _heroProfile?.currentXP ?? 0;
  int get maxXP => _heroProfile?.maxXP ?? 100;

  /// Initialize - Load hero profile from storage
  /// Accepts either a heroName or a heroId (for cross-compat)
  Future<void> init(String heroName) async {
    debugPrint('🚀 [TasksVM] init called with heroName: $heroName');
    _currentHeroName = heroName;
    await _loadHeroProfile();
    debugPrint(
      '📊 [TasksVM] Hero profile loaded: ${_heroProfile?.name ?? "null"}',
    );
    debugPrint(
      '📊 [TasksVM] Current quests count: ${_heroProfile?.quests.length ?? 0}',
    );
    await _cleanupExpiredQuests();
    await _generateRecurringQuests();
  }

  /// Get last selected hero name
  Future<String?> getLastSelectedHero() async {
    return await _repository.getLastSelectedHero();
  }

  /// Load hero profile from repository
  Future<void> _loadHeroProfile() async {
    if (_currentHeroName == null) {
      debugPrint('❌ [TasksVM] Cannot load hero: _currentHeroName is null');
      return;
    }

    debugPrint('📖 [TasksVM] Loading hero profile for: $_currentHeroName');
    _heroProfile = await _repository.loadHeroProfile(_currentHeroName!);

    if (_heroProfile == null) {
      debugPrint('❌ [TasksVM] Hero profile not found in repository!');
    } else {
      debugPrint('✅ [TasksVM] Hero profile loaded: ${_heroProfile!.name}');
      debugPrint('✅ [TasksVM] Hero ID: ${_heroProfile!.id}');
      debugPrint('✅ [TasksVM] Quests: ${_heroProfile!.quests.length}');
    }

    _invalidateCache();
    notifyListeners();
  }

  /// Save hero profile to repository
  Future<void> _saveHeroProfile() async {
    if (_heroProfile != null) {
      await _repository.saveHeroProfile(_heroProfile!);
    }
  }

  /// Clean up expired quests (completed quests older than configured days)
  Future<void> _cleanupExpiredQuests() async {
    if (_heroProfile == null) return;

    final cleanedQuests = QuestCleanupService.removeExpiredQuests(
      _heroProfile!.quests,
    );

    if (cleanedQuests.length != _heroProfile!.quests.length) {
      _heroProfile = _heroProfile!.copyWith(quests: cleanedQuests);
      _invalidateCache();
      await _saveHeroProfile();
      notifyListeners();
    }
  }

  /// Generate any due recurring quests for the current hero
  Future<void> _generateRecurringQuests() async {
    if (_heroProfile == null) return;
    try {
      final updated = await RecurringQuestService.checkAndGenerate(
        _heroProfile!,
        _questRepository,
      );
      if (updated.quests.length != _heroProfile!.quests.length) {
        _heroProfile = updated;
        _invalidateCache();
        await _saveHeroProfile();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Recurring quest generation error: $e');
    }
  }

  /// Get filtered active quests
  List<Quest> get filteredActiveQuests {
    if (_cachedFilteredActiveQuests != null) {
      return _cachedFilteredActiveQuests!;
    }
    _cachedFilteredActiveQuests = allQuests.where((quest) {
      // Only active quests
      if (quest.isCompleted) return false;

      // Filter by search query
      final matchesSearch =
          _searchQuery.isEmpty ||
          quest.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (quest.description?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);

      // Filter by priority
      final matchesPriority =
          _selectedPriority == null || quest.priority == _selectedPriority;

      return matchesSearch && matchesPriority;
    }).toList();

    return _cachedFilteredActiveQuests!;
  }

  /// Get filtered completed quests
  List<Quest> get filteredCompletedQuests {
    if (_cachedFilteredCompletedQuests != null) {
      return _cachedFilteredCompletedQuests!;
    }
    _cachedFilteredCompletedQuests = allQuests.where((quest) {
      // Only completed quests
      if (!quest.isCompleted) return false;

      // Filter by search query
      final matchesSearch =
          _searchQuery.isEmpty ||
          quest.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (quest.description?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);

      // Filter by priority
      final matchesPriority =
          _selectedPriority == null || quest.priority == _selectedPriority;

      return matchesSearch && matchesPriority;
    }).toList();

    return _cachedFilteredCompletedQuests!;
  }

  /// Update search query
  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _invalidateCache();
      notifyListeners();
    }
  }

  /// Update selected priority filter
  void updatePriorityFilter(QuestPriority? priority) {
    if (_selectedPriority != priority) {
      _selectedPriority = priority;
      _invalidateCache();
      notifyListeners();
    }
  }

  /// Add a new quest
  Future<void> addQuest(Quest quest) async {
    debugPrint('🎯 [TasksVM] addQuest called');
    debugPrint('🎯 [TasksVM] Quest: ${quest.title}');
    debugPrint('🎯 [TasksVM] Hero profile: ${_heroProfile?.name ?? "null"}');

    if (_heroProfile == null) {
      debugPrint('❌ [TasksVM] ERROR: Hero profile is null! Cannot add quest.');
      return;
    }

    Quest finalQuest = quest;

    // Check if we need to create a recurring quest based on a dummy recurrenceId generated in AddQuestViewModel
    if (quest.recurrenceId != null &&
        quest.recurrenceId!.endsWith('_recurring')) {
      final typeString = quest.recurrenceId!.replaceAll('_recurring', '');

      final recurrenceType = RecurrenceType.values.firstWhere(
        (t) => t.name == typeString,
        orElse: () => RecurrenceType.daily,
      );

      final recurringQuestId =
          'req_${DateTime.now().millisecondsSinceEpoch.toString()}';

      final recurringQuest = RecurringQuest(
        id: recurringQuestId,
        title: quest.title,
        description: quest.description,
        priority: quest.priority.name,
        recurrenceType: recurrenceType,
        nextDueAt: recurrenceType == RecurrenceType.daily
            ? DateTime.now().add(const Duration(days: 1))
            : recurrenceType == RecurrenceType.weekly
            ? DateTime.now().add(const Duration(days: 7))
            : DateTime.now().add(const Duration(days: 30)),
        heroId: _heroProfile!.id,
      );

      final updatedRecurring = [
        recurringQuest,
        ..._heroProfile!.recurringQuests,
      ];
      _heroProfile = _heroProfile!.copyWith(recurringQuests: updatedRecurring);

      // Update the base quest to hold the real recurring ID
      finalQuest = quest.copyWith(recurrenceId: recurringQuestId);
    }

    debugPrint('✅ [TasksVM] Adding quest to local state optimistically...');

    // Optimistic UI Update
    final updatedQuests = [finalQuest, ..._heroProfile!.quests];
    _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);
    _invalidateCache();

    AudioService().playSfx(AppSound.questAdd);
    notifyListeners();

    // Background process for repo syncing without blocking UI
    _saveHeroProfile().then((_) {
      _questRepository
          .addQuest(finalQuest, _heroProfile!.id)
          .then((syncedQuest) {
            // If ID changed during sync (e.g local generated -> mongo ID), update local references
            if (syncedQuest.id != finalQuest.id && _heroProfile != null) {
              final currentQuests = List<Quest>.from(_heroProfile!.quests);
              final index = currentQuests.indexWhere(
                (q) => q.id == finalQuest.id,
              );
              if (index != -1) {
                currentQuests[index] = syncedQuest;
                _heroProfile = _heroProfile!.copyWith(quests: currentQuests);
                _invalidateCache();
                _saveHeroProfile();
                notifyListeners();
              }
            }
          })
          .catchError((e) {
            debugPrint('❌ [TasksVM] Background sync failed: $e');
          });
    });
  }

  /// Update an existing quest
  Future<void> updateQuest(Quest updatedQuest) async {
    if (_heroProfile == null) return;

    final quests = _heroProfile!.quests;
    final index = quests.indexWhere((q) => q.id == updatedQuest.id);
    if (index != -1) {
      final updatedQuests = List<Quest>.from(quests);
      updatedQuests[index] = updatedQuest;
      _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);
      _invalidateCache();

      notifyListeners();

      // Sync individual quest update in background
      _saveHeroProfile().then((_) {
        _questRepository.updateQuest(updatedQuest).catchError((e) {
          debugPrint('❌ [TasksVM] Background sync failed: $e');
        });
      });
    }
  }

  /// Delete a quest
  Future<void> deleteQuest(String questId) async {
    if (_heroProfile == null) return;

    final updatedQuests = _heroProfile!.quests
        .where((q) => q.id != questId)
        .toList();
    _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);
    _invalidateCache();

    AudioService().playSfx(AppSound.questDelete);
    notifyListeners();

    // Sync quest deletion in background
    _saveHeroProfile().then((_) {
      _questRepository.deleteQuest(questId).catchError((e) {
        debugPrint('❌ [TasksVM] Background sync failed: $e');
      });
    });
  }

  /// Toggle quest completion status
  Future<void> toggleQuestCompletion(String questId) async {
    if (_heroProfile == null) return;

    final quests = _heroProfile!.quests;
    final index = quests.indexWhere((q) => q.id == questId);
    if (index != -1) {
      final quest = quests[index];
      final isBeingCompleted = !quest.isCompleted;
      final updatedQuests = List<Quest>.from(quests);

      updatedQuests[index] = quest.copyWith(
        isCompleted: isBeingCompleted,
        completedAt: isBeingCompleted ? DateTime.now() : null,
      );

      _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);

      // Award XP if quest was just completed, remove XP if uncompleted
      final xpChange = HeroProfile.calculateXPGain(quest.priority);
      if (isBeingCompleted) {
        _heroProfile = _heroProfile!.addXP(xpChange);
        // Update streak tracking
        _heroProfile = _heroProfile!.recordQuestCompletion();
        AudioService().playSfx(AppSound.questComplete);
      } else {
        _heroProfile = _heroProfile!.removeXP(xpChange);
      }

      _invalidateCache();
      notifyListeners();

      _saveHeroProfile().then((_) {
        // Sync quest completion status securely matching the APIs patches in background
        final repo = _questRepository;
        if (repo is SyncQuestRepository) {
          if (isBeingCompleted) {
            repo
                .completeQuest(questId)
                .catchError((e) => debugPrint('Sync error: $e'));
          } else {
            repo
                .uncompleteQuest(questId)
                .catchError((e) => debugPrint('Sync error: $e'));
          }
        } else {
          // Fallback if not using offline first repository
          _questRepository
              .updateQuest(updatedQuests[index])
              .catchError((e) => debugPrint('Sync error: $e'));
        }
      });
    }
  }

  /// Check if quest was just completed (for tab switching logic)
  bool wasQuestJustCompleted(String questId) {
    final quest = allQuests.firstWhere((q) => q.id == questId);
    return quest.isCompleted;
  }

  /// Check if there are any active filters applied
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty || _selectedPriority != null;
  }
}
