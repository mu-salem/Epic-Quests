import 'package:epicquests/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';

import '../../../core/resources/app_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../tasks/data/hero_profile_repository.dart';
import '../../tasks/data/local_hero_profile_repository.dart';
import '../../tasks/model/hero_profile.dart';
import 'widgets/avatar_card.dart';
import 'widgets/avatar_header_card.dart';
import 'widgets/avatar_item.dart';
import 'widgets/avatar_tabs.dart';
import 'widgets/dots_indicator.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  final HeroProfileRepository _repository = LocalHeroProfileRepository();

  // Avatar lists
  final _boys = const [
    AvatarItem(name: 'Arin', asset: AppImages.avatarArin),
    AvatarItem(name: 'Leo', asset: AppImages.avatarLeo),
    AvatarItem(name: 'Jax', asset: AppImages.avatarJax),
    AvatarItem(name: 'Kane', asset: AppImages.avatarKane),
  ];

  final _girls = const [
    AvatarItem(name: 'Luna', asset: AppImages.avatarLuna),
    AvatarItem(name: 'Kira', asset: AppImages.avatarKira),
    AvatarItem(name: 'Elara', asset: AppImages.avatarElara),
    AvatarItem(name: 'Vexa', asset: AppImages.avatarVexa),
  ];

  // State
  bool _isBoysTab = true;
  int _selectedIndex = 0;
  late PageController _pageController;

  // Computed properties
  List<AvatarItem> get _currentAvatars => _isBoysTab ? _boys : _girls;
  AvatarItem get _selectedAvatar => _currentAvatars[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Switch between BOYS and GIRLS tab
  void _switchTab(bool isBoys) {
    if (_isBoysTab == isBoys) return;

    setState(() {
      _isBoysTab = isBoys;
      _selectedIndex = 0; // Reset to first avatar in new tab
    });

    // Reset PageView to first page
    _pageController.jumpToPage(0);
  }

  /// Confirm hero selection
  Future<void> _onConfirm() async {
    final heroName = _selectedAvatar.name;
    final heroGender = _isBoysTab ? 'boy' : 'girl';

    final existingHero = await _repository.loadHeroProfile(heroName);

    if (existingHero != null) {
      await _repository.setLastSelectedHero(heroName);
    } else {
      final newHero = HeroProfile(
        name: heroName,
        avatarAsset: _selectedAvatar.asset,
        gender: heroGender,
        level: 1,
        currentXP: 0,
        quests: [],
      );

      await _repository.saveHeroProfile(newHero);
      await _repository.setLastSelectedHero(heroName);
    }

    // Navigate to home screen with hero name
    if (mounted) {
      context.go('${AppRouter.home}?hero=$heroName');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sliderHeight = 240.h;

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(AppImages.avatarCoverPage, fit: BoxFit.cover),
          ),

          // Blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: AppColors.backgroundDark.withValues(alpha: 0.5),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  SizedBox(height: 8.h),

                  const AvatarHeaderCard(),

                  SizedBox(height: 24.h),

                  AvatarTabs(isBoys: _isBoysTab, onTabChanged: _switchTab),

                  SizedBox(height: 24.h),

                  SizedBox(
                    height: sliderHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _currentAvatars.length,
                      onPageChanged: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedIndex;
                        return AvatarCard(
                          item: _currentAvatars[index],
                          selected: isSelected,
                          onTap: () {
                            setState(() => _selectedIndex = index);
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOut,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),

                  DotsIndicator(
                    count: _currentAvatars.length,
                    index: _selectedIndex,
                  ),

                  const Spacer(),

                  // Confirm button
                  PrimaryButton(
                    text: 'CONFIRM HERO',
                    width: double.infinity,
                    onPressed: _onConfirm,
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
