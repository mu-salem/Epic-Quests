import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'avatar_item.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AvatarItem item;
  final bool selected;
  final VoidCallback onTap;

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
                  SizedBox(height: 10.h),

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

                  SizedBox(height: 8.h),

                  // Name plate inside card
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint50.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selected ? AppColors.primaryTint70 : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      item.name.toUpperCase(),
                      style: AppTextStyles.h4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
