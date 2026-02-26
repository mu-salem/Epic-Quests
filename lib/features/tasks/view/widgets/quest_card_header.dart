import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../model/quest.dart';

class QuestCardHeader extends StatelessWidget {
  final String title;
  final QuestPriority priority;
  final bool isCompleted;
  final VoidCallback onToggleComplete;

  const QuestCardHeader({
    super.key,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Priority Icon
        _getPriorityIcon(priority, width: 24.w, height: 24.h),

        WidthSpacer(8),

        // Quest Title
        Expanded(
          child: Text(
            title,
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
            side: const BorderSide(color: AppColors.backgroundDark, width: 2),
          ),
        ),
      ],
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
