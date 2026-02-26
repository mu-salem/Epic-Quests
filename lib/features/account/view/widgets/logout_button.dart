import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout, color: AppColors.error),
      label: Text(
        'LOGOUT',
        style: AppTextStyles.bodyM.copyWith(
          color: AppColors.error,
          fontFamily: 'PressStart2P',
          fontSize: 10.sp,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.error.withValues(alpha: 0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
