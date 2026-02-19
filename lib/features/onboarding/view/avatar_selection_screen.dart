import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/app_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodel/avatar_selection_viewmodel.dart';
import 'widgets/avatar_card.dart';
import 'widgets/avatar_header_card.dart';
import 'widgets/avatar_tabs.dart';
import 'widgets/dots_indicator.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  late PageController _pageController;
  late AvatarSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AvatarSelectionViewModel();
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 0,
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Listen to ViewModel changes and update PageController if needed
  void _onViewModelChanged() {
    if (_pageController.hasClients) {
      // If tab switched, jump to first page
      if (_pageController.page?.round() != _viewModel.selectedIndex) {
        _pageController.jumpToPage(_viewModel.selectedIndex);
      }
    }
  }

  /// Handle avatar confirmation
  Future<void> _onConfirm() async {
    final route = await _viewModel.confirmHero();
    if (mounted) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sliderHeight = 240.h;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
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

                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) => AvatarTabs(
                        isBoys: viewModel.isBoysTab,
                        onTabChanged: viewModel.switchTab,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) {
                        return SizedBox(
                          height: sliderHeight,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: viewModel.currentAvatars.length,
                            onPageChanged: viewModel.selectAvatar,
                            itemBuilder: (context, index) {
                              final isSelected = index == viewModel.selectedIndex;
                              return AvatarCard(
                                item: viewModel.currentAvatars[index],
                                selected: isSelected,
                                onTap: () {
                                  viewModel.selectAvatar(index);
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 240),
                                    curve: Curves.easeOut,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) => DotsIndicator(
                        count: viewModel.currentAvatars.length,
                        index: viewModel.selectedIndex,
                      ),
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
      ),
    );
  }
}
