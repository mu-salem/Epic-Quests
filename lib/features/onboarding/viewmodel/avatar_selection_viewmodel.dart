import 'package:flutter/foundation.dart';

import '../../../core/routing/app_router.dart';
import '../../tasks/data/repositories/hero_profile_repository.dart';
import '../../tasks/data/repositories/sync_hero_profile_repository.dart';
import '../../tasks/model/hero_profile.dart';
import '../model/avatar_item.dart';
import '../model/avatar_templates.dart';
import '../data/repositories/avatar_repository.dart';
import '../data/local/local_avatar_repository.dart';

class AvatarSelectionViewModel extends ChangeNotifier {
  // Dependencies
  final HeroProfileRepository _heroRepository;
  final AvatarRepository _avatarRepository;

  // State
  bool _isBoysTab = true;
  int _selectedIndex = 0;
  List<AvatarItem> _userAvatars = [];
  bool _isLoading = false;

  // Constructor with dependency injection
  AvatarSelectionViewModel({
    HeroProfileRepository? heroRepository,
    AvatarRepository? avatarRepository,
  }) : _heroRepository = heroRepository ?? SyncHeroProfileRepository(),
       _avatarRepository = avatarRepository ?? LocalAvatarRepository() {
    _loadUserAvatars();
  }

  // Getters
  bool get isBoysTab => _isBoysTab;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  List<AvatarItem> get userAvatars => _userAvatars;
  List<AvatarTemplate> get currentTemplates =>
      AvatarTemplates.byGender(_isBoysTab ? 'boy' : 'girl');
  List<AvatarItem> get currentAvatars => _userAvatars
      .where((a) => a.gender == (_isBoysTab ? 'boy' : 'girl'))
      .toList();
  bool get hasAvatars => _userAvatars.isNotEmpty; // Any avatar in any tab
  bool get hasAvatarsInCurrentTab => currentAvatars.isNotEmpty;
  AvatarItem? get selectedAvatar =>
      hasAvatarsInCurrentTab ? currentAvatars[_selectedIndex] : null;
  AvatarItem? get lastCreatedAvatar =>
      _userAvatars.isNotEmpty ? _userAvatars.last : null;

  /// Get available templates that haven't been used yet
  List<AvatarTemplate> getAvailableTemplates(String gender) {
    final templates = AvatarTemplates.byGender(gender);
    final usedTemplateNames = _userAvatars
        .where((a) => a.gender == gender)
        .map((a) => a.templateName)
        .toSet();

    return templates.where((t) => !usedTemplateNames.contains(t.name)).toList();
  }

  /// Get available templates for current tab
  List<AvatarTemplate> get availableTemplatesForCurrentTab {
    return getAvailableTemplates(_isBoysTab ? 'boy' : 'girl');
  }

  /// Load user avatars from repository
  Future<void> _loadUserAvatars() async {
    _isLoading = true;
    notifyListeners();

    _userAvatars = await _avatarRepository.loadAvatars();
    debugPrint('📊 [Avatar] Loaded ${_userAvatars.length} avatars');
    for (var avatar in _userAvatars) {
      debugPrint('  - ${avatar.displayName} (${avatar.gender}, ${avatar.id})');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh avatars
  Future<void> refreshAvatars() async {
    await _loadUserAvatars();
  }

  /// Switch between BOYS and GIRLS tab
  void switchTab(bool isBoys) {
    if (_isBoysTab == isBoys) return;

    _isBoysTab = isBoys;
    _selectedIndex = 0; // Reset to first avatar in new tab
    notifyListeners();
  }

  /// Select avatar by index
  void selectAvatar(int index) {
    if (_selectedIndex == index) return;

    _selectedIndex = index;
    notifyListeners();
  }

  /// Create new avatar
  Future<void> createAvatar({
    required AvatarTemplate template,
    String? customName,
    String? description,
  }) async {
    final newAvatar = AvatarItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      templateName: template.name,
      asset: template.asset,
      displayName: customName ?? template.name,
      description: description,
      level: 1,
      currentXP: 0,
      gender: template.gender,
      createdAt: DateTime.now(),
    );

    await _avatarRepository.saveAvatar(newAvatar);
    await _loadUserAvatars();
  }

  /// Update avatar details
  Future<void> updateAvatar(AvatarItem avatar) async {
    await _avatarRepository.updateAvatar(avatar);
    await _loadUserAvatars();
  }

  /// Delete avatar
  Future<void> deleteAvatar(String avatarId) async {
    await _avatarRepository.deleteAvatar(avatarId);
    await _loadUserAvatars();
  }

  /// Confirm hero selection and navigate to home
  Future<String> confirmHero() async {
    debugPrint('🎯 [ViewModel] ========== confirmHero START ==========');
    try {
      debugPrint(
        '🎯 [ViewModel] confirmHero called, avatars count: ${_userAvatars.length}',
      );

      _isLoading = true;
      notifyListeners();

      // If no avatars exist, user MUST create one. Prevent continuing.
      if (_userAvatars.isEmpty) {
        debugPrint('⚠️ [ViewModel] No avatars found, blocking confirmation.');
        _isLoading = false;
        notifyListeners();
        return AppRouter.onboardingAvatar;
      }

      // Choose avatar: selected from current tab, or last created, or first available
      debugPrint('🔍 [ViewModel] Finding avatar to use...');
      debugPrint(
        '🔍 [ViewModel] selectedAvatar: ${selectedAvatar?.displayName}',
      );
      debugPrint(
        '🔍 [ViewModel] lastCreatedAvatar: ${lastCreatedAvatar?.displayName}',
      );

      AvatarItem? avatar =
          selectedAvatar ??
          lastCreatedAvatar ??
          (_userAvatars.isNotEmpty ? _userAvatars.first : null);

      if (avatar == null) {
        debugPrint(
          '❌ [ViewModel] CRITICAL: No avatar available after creation!',
        );
        debugPrint('❌ [ViewModel] _userAvatars.length: ${_userAvatars.length}');
        debugPrint('❌ [ViewModel] selectedAvatar: $selectedAvatar');
        debugPrint('❌ [ViewModel] lastCreatedAvatar: $lastCreatedAvatar');
        _isLoading = false;
        notifyListeners();
        return AppRouter.onboardingAvatar;
      }

      debugPrint(
        '✅ [ViewModel] Selected avatar: ${avatar.displayName} (${avatar.id})',
      );

      // Create HeroProfile
      debugPrint('💾 [ViewModel] Creating HeroProfile...');
      final newHero = HeroProfile(
        id: avatar.id,
        name: avatar.displayName,
        avatarAsset: avatar.asset,
        gender: avatar.gender,
        level: avatar.level,
        currentXP: avatar.currentXP,
        quests: [],
      );

      debugPrint('💾 [ViewModel] Saving hero to repository...');
      final savedHero = await _heroRepository.saveHeroProfile(newHero);
      debugPrint('✅ [ViewModel] Hero saved with ID: ${savedHero.id}');

      debugPrint('💾 [ViewModel] Setting last selected hero...');
      await _heroRepository.setLastSelectedHero(savedHero.id);
      debugPrint('✅ [ViewModel] Last selected hero set');

      _isLoading = false;
      notifyListeners();

      // Return the route to navigate to
      final route = '${AppRouter.home}?hero=${savedHero.id}';
      debugPrint('🚀 [ViewModel] Returning route: $route');
      debugPrint(
        '🎯 [ViewModel] ========== confirmHero END (SUCCESS) ==========',
      );
      return route;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ [ViewModel] ========== EXCEPTION in confirmHero ==========',
      );
      debugPrint('❌ [ViewModel] Error in confirmHero: $e');
      debugPrint('❌ [ViewModel] Error type: ${e.runtimeType}');
      debugPrint('❌ [ViewModel] Stack trace: $stackTrace');
      debugPrint('❌ [ViewModel] ========== confirmHero END (ERROR) ==========');
      _isLoading = false;
      notifyListeners();
      return AppRouter.onboardingAvatar;
    }
  }
}
