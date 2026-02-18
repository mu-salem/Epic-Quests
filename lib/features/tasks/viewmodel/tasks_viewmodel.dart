import 'package:flutter/foundation.dart';

import '../../../core/resources/app_images.dart';
import '../../../core/services/quest_cleanup_service.dart';
import '../data/hero_profile_repository.dart';
import '../data/local_hero_profile_repository.dart';
import '../model/hero_profile.dart';
import '../model/quest.dart';


class TasksViewModel extends ChangeNotifier {
  // Dependencies
  final HeroProfileRepository _repository;

  // Current Hero
  String? _currentHeroName;
  
  // Hero Profile
  HeroProfile? _heroProfile;

  // Search & Filter State
  String _searchQuery = '';
  QuestPriority? _selectedPriority;

  // Constructor with dependency injection
  TasksViewModel({
    HeroProfileRepository? repository,
  }) : _repository = repository ?? LocalHeroProfileRepository();

  // Getters
  String? get currentHeroName => _currentHeroName;
  HeroProfile? get heroProfile => _heroProfile;
  String get searchQuery => _searchQuery;
  QuestPriority? get selectedPriority => _selectedPriority;
  List<Quest> get allQuests => _heroProfile?.quests ?? [];

  // Hero stats getters
  String get heroName => _heroProfile?.name ?? 'Hero';
  String get avatarAsset => _heroProfile?.avatarAsset ?? AppImages.defaultAvatar;
  int get level => _heroProfile?.level ?? 1;
  int get currentXP => _heroProfile?.currentXP ?? 0;
  int get maxXP => _heroProfile?.maxXP ?? 100;

  /// Initialize - Load hero profile from storage
  Future<void> init(String heroName) async {
    _currentHeroName = heroName;
    await _loadHeroProfile();
    await _cleanupExpiredQuests();
  }
  
  /// Get last selected hero name
  Future<String?> getLastSelectedHero() async {
    return await _repository.getLastSelectedHero();
  }

  /// Load hero profile from repository
  Future<void> _loadHeroProfile() async {
    if (_currentHeroName == null) return;
    _heroProfile = await _repository.loadHeroProfile(_currentHeroName!);
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

    final cleanedQuests = QuestCleanupService.removeExpiredQuests(_heroProfile!.quests);

    if (cleanedQuests.length != _heroProfile!.quests.length) {
      _heroProfile = _heroProfile!.copyWith(quests: cleanedQuests);
      await _saveHeroProfile();
      notifyListeners();
    }
  }

  /// Get filtered active quests
  List<Quest> get filteredActiveQuests {
    return allQuests.where((quest) {
      // Only active quests
      if (quest.isCompleted) return false;

      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          quest.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (quest.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      // Filter by priority
      final matchesPriority = _selectedPriority == null ||
          quest.priority == _selectedPriority;

      return matchesSearch && matchesPriority;
    }).toList();
  }

  /// Get filtered completed quests
  List<Quest> get filteredCompletedQuests {
    return allQuests.where((quest) {
      // Only completed quests
      if (!quest.isCompleted) return false;

      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          quest.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (quest.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      // Filter by priority
      final matchesPriority = _selectedPriority == null ||
          quest.priority == _selectedPriority;

      return matchesSearch && matchesPriority;
    }).toList();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Update selected priority filter
  void updatePriorityFilter(QuestPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  /// Add a new quest
  Future<void> addQuest(Quest quest) async {
    if (_heroProfile == null) return;

    final updatedQuests = [quest, ..._heroProfile!.quests];
    _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);
    await _saveHeroProfile();
    notifyListeners();
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
      await _saveHeroProfile();
      notifyListeners();
    }
  }

  /// Delete a quest
  Future<void> deleteQuest(String questId) async {
    if (_heroProfile == null) return;

    final updatedQuests = _heroProfile!.quests.where((q) => q.id != questId).toList();
    _heroProfile = _heroProfile!.copyWith(quests: updatedQuests);
    await _saveHeroProfile();
    notifyListeners();
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
      } else {
        _heroProfile = _heroProfile!.removeXP(xpChange);
      }

      await _saveHeroProfile();
      notifyListeners();
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
