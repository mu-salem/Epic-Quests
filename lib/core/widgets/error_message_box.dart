import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Simple error message box to display above buttons
class ErrorMessageBox extends StatelessWidget {
  const ErrorMessageBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.error, width: 2),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyS.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
