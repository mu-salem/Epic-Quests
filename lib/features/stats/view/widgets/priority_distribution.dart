import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/quest.dart';

class PriorityDistribution extends StatelessWidget {
  final Map<QuestPriority, int> distribution;

  const PriorityDistribution({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(0, (s, v) => s + v);
    final safeTotal = total == 0 ? 1 : total;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: QuestPriority.values.map((priority) {
          final count = distribution[priority] ?? 0;
          final fraction = count / safeTotal;
          final color = _colorForPriority(priority);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                _getPriorityIcon(priority, width: 14.w, height: 14.h),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 50.w,
                  child: Text(
                    priority.label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 5.sp,
                      color: color,
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 6.sp,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _colorForPriority(QuestPriority priority) {
    switch (priority) {
      case QuestPriority.low:
        return AppColors.priorityLow;
      case QuestPriority.medium:
        return AppColors.priorityMedium;
      case QuestPriority.high:
        return AppColors.priorityHigh;
    }
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
