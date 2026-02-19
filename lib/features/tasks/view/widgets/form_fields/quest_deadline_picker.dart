import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Deadline picker widget for quest form
class QuestDeadlinePicker extends StatelessWidget {
  const QuestDeadlinePicker({
    super.key,
    required this.deadline,
    required this.onTap,
  });

  final DateTime? deadline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deadline (Optional)',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.panelDark,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18.sp,
                  color: AppColors.textMuted,
                ),
                SizedBox(width: 10.w),
                Text(
                  deadline != null
                      ? '${deadline!.day}/${deadline!.month}/${deadline!.year}'
                      : 'Select deadline',
                  style: AppTextStyles.bodyM.copyWith(
                    color: deadline != null
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
