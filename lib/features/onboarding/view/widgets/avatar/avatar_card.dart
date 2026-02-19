import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  final AvatarItem item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    // Hero Focus: selected bigger and brighter, others slightly faded
    final scale = selected ? 1.0 : 0.90;
    final opacity = selected ? 1.0 : 0.55;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: selected ? AppColors.primaryTint70 : AppColors.border,
                  width: selected ? 2.2 : 1.2,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.primaryShade90,
                    AppColors.backgroundSoft,
                  ],
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 26,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.18),
                          blurRadius: 14,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        )
                      ],
              ),
              child: Column(
                children: [
                  HeightSpacer(10),

                  // Avatar image
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Image.asset(
                        item.asset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  HeightSpacer(8),

                  // Level & XP badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: AppColors.accent, size: 14.sp),
                            WidthSpacer(4),
                            Text(
                              'Lvl ${item.level}',
                              style: AppTextStyles.bodyS.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      WidthSpacer(8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.indigo.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.indigo, width: 1.5),
                        ),
                        child: Text(
                          '${item.currentXP} XP',
                          style: AppTextStyles.bodyS.copyWith(
                            color: AppColors.primaryTint70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  HeightSpacer(8),

                  // Name plate inside card
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    margin: EdgeInsets.only(bottom: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint50.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selected ? AppColors.primaryTint70 : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      item.displayName.toUpperCase(),
                      style: AppTextStyles.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Description (if exists)
                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h, left: 12.w, right: 12.w),
                      child: Text(
                        item.description!,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    HeightSpacer(4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
