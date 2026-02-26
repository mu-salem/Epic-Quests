import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileStatChip extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;

  const ProfileStatChip({
    super.key,
    required this.iconWidget,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            iconWidget,
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 7.sp,
                color: AppColors.accent,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 10.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
