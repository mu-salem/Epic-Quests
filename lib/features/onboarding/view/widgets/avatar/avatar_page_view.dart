import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:epicquests/features/onboarding/viewmodel/avatar_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:epicquests/core/theme/app_colors.dart';
import 'avatar_card.dart';
import 'avatar_empty_state.dart';

/// PageView for displaying avatars with loading and empty states
class AvatarPageView extends StatelessWidget {
  final PageController pageController;
  final double height;
  final Function(AvatarItem) onLongPress;

  const AvatarPageView({
    super.key,
    required this.pageController,
    required this.height,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AvatarSelectionViewModel>(
      builder: (context, viewModel, _) {
        // Loading state
        if (viewModel.isLoading) {
          return SizedBox(
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            ),
          );
        }

        // Empty state
        if (!viewModel.hasAvatars) {
          return SizedBox(
            height: height,
            child: const AvatarEmptyState(),
          );
        }

        // Avatar PageView
        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: pageController,
            itemCount: viewModel.currentAvatars.length,
            onPageChanged: viewModel.selectAvatar,
            itemBuilder: (context, index) {
              final isSelected = index == viewModel.selectedIndex;
              final avatar = viewModel.currentAvatars[index];

              return AvatarCard(
                item: avatar,
                selected: isSelected,
                onTap: () {
                  viewModel.selectAvatar(index);
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                  );
                },
                onLongPress: () => onLongPress(avatar),
              );
            },
          ),
        );
      },
    );
  }
}
