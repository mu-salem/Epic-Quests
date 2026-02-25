import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';

/// Preview card showing avatar image, name, level and XP
class AvatarPreviewCard extends StatelessWidget {
  final AvatarItem avatar;

  const AvatarPreviewCard({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar Image
        Center(
          child: Container(
            width: 120.w,
            height: 120.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.panelDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: Image.asset(avatar.asset, fit: BoxFit.contain),
          ),
        ),

        HeightSpacer(8),

        // Template Name Badge
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Text(
              avatar.templateName,
              style: AppTextStyles.bodyS.copyWith(
                color: AppColors.primaryTint70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        HeightSpacer(24),

        // Stats Row (Level & XP)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.accent, size: 16.sp),
                  WidthSpacer(6),
                  Text(
                    'Level ${avatar.level}',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            WidthSpacer(12),
            // XP Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.indigo.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.indigo, width: 1.5),
              ),
              child: Text(
                '${avatar.currentXP} XP',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.primaryTint70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
