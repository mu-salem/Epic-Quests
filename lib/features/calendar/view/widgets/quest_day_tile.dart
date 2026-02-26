import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/quest.dart';

class QuestDayTile extends StatelessWidget {
  final Quest quest;
  final VoidCallback onTap;

  const QuestDayTile({super.key, required this.quest, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundSoft,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: quest.isCompleted
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            _getPriorityIcon(quest.priority, width: 18.w, height: 18.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                quest.title,
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 22.sp,
                  color: quest.isCompleted
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  decoration: quest.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            if (quest.isCompleted)
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _getPriorityIcon(
    QuestPriority priority, {
    double? width,
    double? height,
  }) {
    switch (priority) {
      case QuestPriority.low:
        return AppIcons.lowPriority(width: width, height: height);
      case QuestPriority.medium:
        return AppIcons.mediumPriority(width: width, height: height);
      case QuestPriority.high:
        return AppIcons.highPriority(width: width, height: height);
    }
  }
}
