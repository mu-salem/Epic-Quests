import 'package:flutter/foundation.dart';
import '../../tasks/data/repositories/sync_hero_profile_repository.dart';
import '../../tasks/model/hero_profile.dart';
import '../../tasks/viewmodel/tasks_viewmodel.dart';
import '../../../core/services/audio_service.dart';
import '../../onboarding/data/repositories/avatar_repository.dart';
import '../../onboarding/data/local/local_avatar_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final SyncHeroProfileRepository _repository;
  final AvatarRepository _avatarRepository;
  final TasksViewModel _tasksViewModel;

  List<HeroProfile> _heroes = [];
  HeroProfile? _activeHero;
  bool _isLoading = false;
  String? _error;

  ProfileViewModel({
    SyncHeroProfileRepository? repository,
    AvatarRepository? avatarRepository,
    required TasksViewModel tasksViewModel,
  }) : _repository = repository ?? SyncHeroProfileRepository(),
       _avatarRepository = avatarRepository ?? LocalAvatarRepository(),
       _tasksViewModel = tasksViewModel;

  List<HeroProfile> get heroes => _heroes;
  HeroProfile? get activeHero => _activeHero;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _heroes = await _repository.getAllHeroes();
      final lastName = await _repository.getLastSelectedHero();
      if (lastName != null) {
        _activeHero = _heroes.firstWhere(
          (h) => h.id == lastName || h.name == lastName,
          orElse: () => _heroes.isNotEmpty ? _heroes.first : _activeHero!,
        );
      } else if (_heroes.isNotEmpty) {
        _activeHero = _heroes.first;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectHero(HeroProfile hero) async {
    await _repository.selectHero(hero.id);
    _activeHero = hero;
    // Also update tasks viewmodel
    await _tasksViewModel.init(hero.id);
    notifyListeners();
  }

  Future<void> deleteHero(String heroId) async {
    await _repository.deleteHeroProfile(heroId);
    await _avatarRepository.deleteAvatar(heroId);
    _heroes.removeWhere((h) => h.id == heroId);
    if (_activeHero?.id == heroId) {
      _activeHero = _heroes.isNotEmpty ? _heroes.first : null;
    }
    notifyListeners();
  }

  bool get isSoundEnabled => AudioService().isSoundEnabled;

  Future<void> toggleSound() async {
    await AudioService().toggleSound();
    notifyListeners();
  }

  /// Statistics for the active hero
  ProfileStats getStatsForHero(HeroProfile hero) {
    final completed = hero.quests.where((q) => q.isCompleted).length;
    final active = hero.quests.where((q) => !q.isCompleted).length;
    final total = hero.quests.length;
    final rate = total > 0 ? (completed / total * 100).round() : 0;

    return ProfileStats(
      completedQuests: completed,
      activeQuests: active,
      completionRate: rate,
      currentStreak: hero.currentStreak,
      longestStreak: hero.longestStreak,
      totalCompletedAllTime: hero.totalCompletedQuests,
    );
  }
}

class ProfileStats {
  final int completedQuests;
  final int activeQuests;
  final int completionRate;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletedAllTime;

  const ProfileStats({
    required this.completedQuests,
    required this.activeQuests,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletedAllTime,
  });
}
