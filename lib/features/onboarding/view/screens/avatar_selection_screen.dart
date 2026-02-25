import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/avatar_selection_viewmodel.dart';
import '../../model/avatar_item.dart';
import '../widgets/avatar/avatar_background.dart';
import '../widgets/avatar/avatar_header_card.dart';
import '../widgets/avatar/avatar_tabs.dart';
import '../widgets/avatar/avatar_page_view.dart';
import '../widgets/common/dots_indicator.dart';
import '../widgets/bottom_sheets/add_avatar_bottom_sheet.dart';
import '../widgets/bottom_sheets/edit_avatar_bottom_sheet.dart';

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
    _pageController = PageController(viewportFraction: 0.5, initialPage: 0);
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
    if (_pageController.hasClients && _viewModel.hasAvatars) {
      // If tab switched, jump to first page
      if (_pageController.page?.round() != _viewModel.selectedIndex + 1) {
        _pageController.jumpToPage(_viewModel.selectedIndex + 1);
      }
    }
  }

  /// Handle avatar confirmation
  Future<void> _onConfirm() async {
    debugPrint('🎯 [Avatar] ========== _onConfirm START ==========');
    try {
      debugPrint('🎯 [Avatar] Confirm button pressed');
      debugPrint('🎯 [Avatar] Calling confirmHero...');
      final route = await _viewModel.confirmHero();
      debugPrint('🎯 [Avatar] Route received: $route');

      if (mounted) {
        debugPrint('🎯 [Avatar] Widget is mounted, navigating to: $route');
        context.go(route);
        debugPrint('✅ [Avatar] Navigation called');
        debugPrint(
          '🎯 [Avatar] ========== _onConfirm END (SUCCESS) ==========',
        );
      } else {
        debugPrint('❌ [Avatar] Widget not mounted!');
        debugPrint(
          '🎯 [Avatar] ========== _onConfirm END (NOT MOUNTED) ==========',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [Avatar] ========== EXCEPTION in _onConfirm ==========');
      debugPrint('❌ [Avatar] Error in _onConfirm: $e');
      debugPrint('❌ [Avatar] Error type: ${e.runtimeType}');
      debugPrint('❌ [Avatar] Stack trace: $stackTrace');
      debugPrint('🎯 [Avatar] ========== _onConfirm END (ERROR) ==========');
    }
  }

  /// Show add avatar bottom sheet
  void _showAddAvatarSheet() {
    final availableTemplates = _viewModel.availableTemplatesForCurrentTab;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => AddAvatarBottomSheet(
        templates: availableTemplates,
        onCreateAvatar: (template, customName, description) async {
          await _viewModel.createAvatar(
            template: template,
            customName: customName,
            description: description,
          );
        },
      ),
    );
  }

  /// Show edit avatar bottom sheet
  void _showEditAvatarSheet(AvatarItem avatar) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => EditAvatarBottomSheet(
        avatar: avatar,
        onUpdate: (customName, description) async {
          final updatedAvatar = avatar.copyWith(
            displayName: customName ?? avatar.templateName,
            description: description,
          );
          await _viewModel.updateAvatar(updatedAvatar);
        },
        onDelete: () async {
          await _viewModel.deleteAvatar(avatar.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sliderHeight = 240.h;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.transparent,

        body: Stack(
          children: [
            // Background with blur
            const Positioned.fill(child: AvatarBackground()),

            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    HeightSpacer(8),

                    const AvatarHeaderCard(),

                    HeightSpacer(24),

                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) => AvatarTabs(
                        isBoys: viewModel.isBoysTab,
                        onTabChanged: viewModel.switchTab,
                      ),
                    ),

                    HeightSpacer(24),

                    // Avatar PageView with loading and empty states
                    AvatarPageView(
                      pageController: _pageController,
                      height: sliderHeight,
                      onLongPress: _showEditAvatarSheet,
                      onCreateTap: _showAddAvatarSheet,
                    ),

                    HeightSpacer(16),

                    // Dots Indicator
                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) {
                        if (!viewModel.hasAvatars) {
                          return const SizedBox.shrink();
                        }
                        return DotsIndicator(
                          count: viewModel.currentAvatars.length + 1,
                          // Index + 1 because UI page index 0 is "Create"
                          index: viewModel.selectedIndex + 1,
                        );
                      },
                    ),

                    const Spacer(),

                    // Confirm button
                    Consumer<AvatarSelectionViewModel>(
                      builder: (context, viewModel, _) => PrimaryButton(
                        text: 'CONFIRM HERO',
                        width: double.infinity,
                        onPressed: viewModel.isLoading || !viewModel.hasAvatars
                            ? null
                            : _onConfirm,
                        isLoading: viewModel.isLoading,
                      ),
                    ),

                    HeightSpacer(12),
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
