import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.iconWidget,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundSoft,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                iconWidget,
                const Spacer(),
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12.sp,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 12.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
