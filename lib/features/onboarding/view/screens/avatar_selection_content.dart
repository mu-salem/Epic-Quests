import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../viewmodel/avatar_selection_viewmodel.dart';
import '../../model/avatar_item.dart';
import '../widgets/avatar/avatar_header_card.dart';
import '../widgets/avatar/avatar_tabs.dart';
import '../widgets/avatar/avatar_page_view.dart';
import '../widgets/common/dots_indicator.dart';

class AvatarSelectionContent extends StatelessWidget {
  const AvatarSelectionContent({
    super.key,
    required this.pageController,
    required this.onShowEditAvatarSheet,
    required this.onShowAddAvatarSheet,
    required this.onConfirm,
  });

  final PageController pageController;
  final Function(AvatarItem) onShowEditAvatarSheet;
  final VoidCallback onShowAddAvatarSheet;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final sliderHeight = 240.h;

    return SafeArea(
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
              pageController: pageController,
              height: sliderHeight,
              onLongPress: onShowEditAvatarSheet,
              onCreateTap: onShowAddAvatarSheet,
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
                    : onConfirm,
                isLoading: viewModel.isLoading,
              ),
            ),

            HeightSpacer(12),
          ],
        ),
      ),
    );
  }
}
