import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Pixel-styled header card for auth screens
class PixelHeaderCard extends StatelessWidget {
  const PixelHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.panelDark,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.border,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.accent,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          HeightSpacer(12),
          Text(
            subtitle,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
