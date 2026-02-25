import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:epicquests/features/onboarding/viewmodel/avatar_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:epicquests/core/theme/app_colors.dart';
import 'avatar_card.dart';
import 'create_avatar_card.dart';

/// PageView for displaying avatars with loading and empty states
class AvatarPageView extends StatelessWidget {
  final PageController pageController;
  final double height;
  final Function(AvatarItem) onLongPress;
  final VoidCallback onCreateTap;

  const AvatarPageView({
    super.key,
    required this.pageController,
    required this.height,
    required this.onLongPress,
    required this.onCreateTap,
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
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          );
        }

        // Empty state is now handled natively by the PageView rendering the +1 Create card

        // Avatar PageView
        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: pageController,
            itemCount:
                viewModel.currentAvatars.length + 1, // +1 for "Create" card
            onPageChanged: (index) {
              if (index > 0) {
                // Determine the correct avatar index since index 0 is "Create"
                viewModel.selectAvatar(index - 1);
              }
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return CreateAvatarCard(onTap: onCreateTap);
              }

              final avatarIndex = index - 1;
              final isSelected = avatarIndex == viewModel.selectedIndex;
              final avatar = viewModel.currentAvatars[avatarIndex];

              return AvatarCard(
                item: avatar,
                selected: isSelected,
                onTap: () {
                  viewModel.selectAvatar(avatarIndex);
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
