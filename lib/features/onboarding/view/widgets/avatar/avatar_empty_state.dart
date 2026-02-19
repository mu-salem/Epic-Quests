import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// Empty state for when no avatars exist
class AvatarEmptyState extends StatelessWidget {
  const AvatarEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_outlined,
            size: 80.sp,
            color: AppColors.textMuted,
          ),
          HeightSpacer(16),
          Text(
            'NO AVATARS YET',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          HeightSpacer(8),
          Text(
            'Create your first avatar to begin',
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
