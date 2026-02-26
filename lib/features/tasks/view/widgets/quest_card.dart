import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/quest.dart';
import 'quest_card_header.dart';
import 'quest_card_footer.dart';

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
              QuestCardHeader(
                title: quest.title,
                priority: quest.priority,
                isCompleted: isCompleted,
                onToggleComplete: onToggleComplete,
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

              QuestCardFooter(
                dueDate: quest.deadline,
                isCompleted: isCompleted,
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
}
