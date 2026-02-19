import 'package:flutter/foundation.dart';

import '../../../core/routing/app_router.dart';
import '../../tasks/data/repositories/hero_profile_repository.dart';
import '../../tasks/data/local/local_hero_profile_repository.dart';
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
  })  : _heroRepository = heroRepository ?? LocalHeroProfileRepository(),
        _avatarRepository = avatarRepository ?? LocalAvatarRepository() {
    _loadUserAvatars();
  }

  // Getters
  bool get isBoysTab => _isBoysTab;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  List<AvatarItem> get userAvatars => _userAvatars;
  List<AvatarTemplate> get currentTemplates => AvatarTemplates.byGender(_isBoysTab ? 'boy' : 'girl');
  List<AvatarItem> get currentAvatars => _userAvatars.where((a) => a.gender == (_isBoysTab ? 'boy' : 'girl')).toList();
  bool get hasAvatars => currentAvatars.isNotEmpty;
  AvatarItem? get selectedAvatar => hasAvatars ? currentAvatars[_selectedIndex] : null;

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
    if (selectedAvatar == null) {
      return AppRouter.onboardingAvatar; // Stay on same screen if no avatar selected
    }

    final avatar = selectedAvatar!;
    final existingHero = await _heroRepository.loadHeroProfile(avatar.id);

    if (existingHero != null) {
      await _heroRepository.setLastSelectedHero(avatar.id);
    } else {
      final newHero = HeroProfile(
        name: avatar.displayName,
        avatarAsset: avatar.asset,
        gender: avatar.gender,
        level: avatar.level,
        currentXP: avatar.currentXP,
        quests: [],
      );

      await _heroRepository.saveHeroProfile(newHero);
      await _heroRepository.setLastSelectedHero(avatar.id);
    }

    // Return the route to navigate to
    return '${AppRouter.home}?hero=${avatar.id}';
  }
}
