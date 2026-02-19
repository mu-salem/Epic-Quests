import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    this.avatarAsset = AppImages.defaultAvatar,
    this.heroName = 'ARIN',
    this.level = 1,
    this.currentXP = 0,
    this.maxXP = 100,
    this.onTap,
  });

  final String avatarAsset;
  final String heroName;
  final int level;
  final int currentXP;
  final int maxXP;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final xpProgress = maxXP > 0 ? currentXP / maxXP : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.panelDark,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
        children: [
          // Avatar
          Container(
            width: 80.w,
            height: 90.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryTint70, width: 2),
              image: DecorationImage(
                image: AssetImage(avatarAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),

          WidthSpacer(12),

          // Hero Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Name
                Text(
                  heroName.toUpperCase(),
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                HeightSpacer(4),

                // Level Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Text(
                    'LV $level',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                HeightSpacer(8),

                // XP Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XP: $currentXP / $maxXP',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    HeightSpacer(4),
                    Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3.r),
                        child: LinearProgressIndicator(
                          value: xpProgress.clamp(0.0, 1.0),
                          backgroundColor: AppColors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryTint70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
