import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/quest.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.onToggleComplete,
    this.onTap,
  });

  final Quest quest;
  final VoidCallback onToggleComplete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest.isCompleted;
    final priorityColor = _getPriorityColor(quest.priority);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: isCompleted ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.panelLight,
                AppColors.panelLight.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted ? AppColors.border : priorityColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row with Priority Icon
              Row(
                children: [
                  // Priority Icon
                  _getPriorityIcon(quest.priority, width: 24.w, height: 24.h),

                  WidthSpacer(8),

                  // Quest Title
                  Expanded(
                    child: Text(
                      quest.title,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.backgroundDark,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  WidthSpacer(8),

                  // Complete Checkbox
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: isCompleted,
                      onChanged: (_) => onToggleComplete(),
                      activeColor: AppColors.success,
                      checkColor: AppColors.white,
                      side: BorderSide(
                        color: AppColors.backgroundDark,
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),

              // Description (if exists)
              if (quest.description != null &&
                  quest.description!.isNotEmpty) ...[
                HeightSpacer(8),
                Text(
                  quest.description!,
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.backgroundDark.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              HeightSpacer(10),

              // Bottom Row: Deadline & Status Badge
              Row(
                children: [
                  // Deadline
                  if (quest.deadline != null)
                    Row(
                      children: [
                        AppIcons.timeSpentHourglass(width: 16.w, height: 16.h),
                        WidthSpacer(4),
                        Text(
                          'Due: ${_formatDate(quest.deadline!)}',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.backgroundDark.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const Spacer(),

                  // Completed Badge
                  if (isCompleted)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 1,
                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get color based on priority
  Color _getPriorityColor(QuestPriority priority) {
    switch (priority) {
      case QuestPriority.low:
        return AppColors.priorityLow;
      case QuestPriority.medium:
        return AppColors.priorityMedium;
      case QuestPriority.high:
        return AppColors.priorityHigh;
    }
  }

  /// Get icon based on priority
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

  /// Format date to readable string
  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }
}
