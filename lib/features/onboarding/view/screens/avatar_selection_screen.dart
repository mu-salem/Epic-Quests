import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/avatar_selection_viewmodel.dart';
import '../../model/avatar_item.dart';
import '../widgets/avatar/avatar_background.dart';
import 'avatar_selection_content.dart';
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
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: Stack(
          children: [
            // Background with blur
            const Positioned.fill(child: AvatarBackground()),

            // Main content
            AvatarSelectionContent(
              pageController: _pageController,
              onShowEditAvatarSheet: _showEditAvatarSheet,
              onShowAddAvatarSheet: _showAddAvatarSheet,
              onConfirm: _onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
