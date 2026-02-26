import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/spacing_widgets.dart';

class QuestCardFooter extends StatelessWidget {
  final DateTime? dueDate;
  final bool isCompleted;

  const QuestCardFooter({super.key, this.dueDate, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Deadline
        if (dueDate != null)
          Row(
            children: [
              AppIcons.timeSpentHourglass(width: 16.w, height: 16.h),
              WidthSpacer(4),
              Text(
                'Due: ${_formatDate(dueDate!)}',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.backgroundDark.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

        const Spacer(),

        // Completed Badge
        if (isCompleted)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.backgroundDark, width: 1),
            ),
            child: Text(
              'COMPLETED',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }
}
