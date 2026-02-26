import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

Future<bool?> showDeleteQuestDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.panelDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border, width: 2),
      ),
      title: Text(
        'Delete Quest?',
        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
      ),
      content: Text(
        'Are you sure you want to delete this quest? This action cannot be undone.',
        style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'CANCEL',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textMuted,
              fontSize: 13.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'DELETE',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.error,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
