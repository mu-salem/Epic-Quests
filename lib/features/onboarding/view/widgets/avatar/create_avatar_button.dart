import 'package:epicquests/features/onboarding/viewmodel/avatar_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';

/// Button to create new avatar - only visible when templates are available
class CreateAvatarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateAvatarButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AvatarSelectionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.availableTemplatesForCurrentTab.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(Icons.add_circle_outline, size: 20.sp),
            label: Text(
              'CREATE AVATAR',
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent, width: 2),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
