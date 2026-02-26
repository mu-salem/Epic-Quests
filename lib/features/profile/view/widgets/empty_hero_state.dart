import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyHeroState extends StatelessWidget {
  const EmptyHeroState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text('👻', style: TextStyle(fontSize: 48.sp)),
          SizedBox(height: 12.h),
          Text(
            'NO HERO SELECTED',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 8.sp,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create a hero to begin your quest!',
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
