import 'package:flutter/foundation.dart';

import '../../../core/resources/app_images.dart';
import '../../../core/routing/app_router.dart';
import '../../tasks/data/hero_profile_repository.dart';
import '../../tasks/data/local_hero_profile_repository.dart';
import '../../tasks/model/hero_profile.dart';
import '../model/avatar_item.dart';

class AvatarSelectionViewModel extends ChangeNotifier {
  // Dependencies
  final HeroProfileRepository _repository;

  // Avatar lists
  static const List<AvatarItem> boys = [
    AvatarItem(name: 'Arin', asset: AppImages.avatarArin),
    AvatarItem(name: 'Leo', asset: AppImages.avatarLeo),
    AvatarItem(name: 'Jax', asset: AppImages.avatarJax),
    AvatarItem(name: 'Kane', asset: AppImages.avatarKane),
  ];

  static const List<AvatarItem> girls = [
    AvatarItem(name: 'Luna', asset: AppImages.avatarLuna),
    AvatarItem(name: 'Kira', asset: AppImages.avatarKira),
    AvatarItem(name: 'Elara', asset: AppImages.avatarElara),
    AvatarItem(name: 'Vexa', asset: AppImages.avatarVexa),
  ];

  // State
  bool _isBoysTab = true;
  int _selectedIndex = 0;

  // Constructor with dependency injection
  AvatarSelectionViewModel({
    HeroProfileRepository? repository,
  }) : _repository = repository ?? LocalHeroProfileRepository();

  // Getters
  bool get isBoysTab => _isBoysTab;
  int get selectedIndex => _selectedIndex;
  List<AvatarItem> get currentAvatars => _isBoysTab ? boys : girls;
  AvatarItem get selectedAvatar => currentAvatars[_selectedIndex];

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

  /// Confirm hero selection and navigate to home
  Future<String> confirmHero() async {
    final heroName = selectedAvatar.name;
    final heroGender = _isBoysTab ? 'boy' : 'girl';

    final existingHero = await _repository.loadHeroProfile(heroName);

    if (existingHero != null) {
      await _repository.setLastSelectedHero(heroName);
    } else {
      final newHero = HeroProfile(
        name: heroName,
        avatarAsset: selectedAvatar.asset,
        gender: heroGender,
        level: 1,
        currentXP: 0,
        quests: [],
      );

      await _repository.saveHeroProfile(newHero);
      await _repository.setLastSelectedHero(heroName);
    }

    // Return the route to navigate to
    return '${AppRouter.home}?hero=$heroName';
  }
}
