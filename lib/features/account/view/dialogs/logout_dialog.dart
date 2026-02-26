import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.backgroundSoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: AppColors.error, width: 2),
      ),
      title: Text(
        '⚠️ LOGOUT?',
        style: TextStyle(
          fontFamily: 'PressStart2P',
          fontSize: 8.sp,
          color: AppColors.error,
        ),
      ),
      content: Text(
        'Are you sure you want to log out of your account?',
        style: TextStyle(
          fontFamily: 'VT323',
          fontSize: 16.sp,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 7.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            'LOGOUT',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 7.sp,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    ),
  );
}
