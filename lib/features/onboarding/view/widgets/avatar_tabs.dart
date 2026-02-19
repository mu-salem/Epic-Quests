import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Avatar Tabs - Switch between BOYS and GIRLS
class AvatarTabs extends StatelessWidget {
  const AvatarTabs({
    super.key,
    required this.isBoys,
    required this.onTabChanged,
  });

  final bool isBoys;
  final ValueChanged<bool> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panelDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Row(
        children: [
          // BOYS tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: isBoys ? AppColors.primary : AppColors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: isBoys
                      ? [
                          BoxShadow(
                            color: AppColors.primary..withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'BOYS',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4.copyWith(
                    color: isBoys ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          // GIRLS tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: !isBoys ? AppColors.primary : AppColors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: !isBoys
                      ? [
                          BoxShadow(
                            color: AppColors.primary..withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'GIRLS',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4.copyWith(
                    color: !isBoys ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
