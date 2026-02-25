import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/spacing_widgets.dart';
import '../../../model/quest.dart';

/// Priority selector widget for quest form
class QuestPrioritySelector extends StatelessWidget {
  const QuestPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  final QuestPriority selectedPriority;
  final ValueChanged<QuestPriority> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
        ),
        HeightSpacer(8),
        Row(
          children: QuestPriority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            return Expanded(
              child: GestureDetector(
                onTap: () => onPriorityChanged(priority),
                child: Container(
                  margin: EdgeInsets.only(
                    right: priority != QuestPriority.high ? 8.w : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.panelDark,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryTint70
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      _getPriorityIcon(priority, width: 24.w, height: 24.h),
                      HeightSpacer(4),
                      Text(
                        priority.label,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 13.sp,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Helper to get the equivalent priority AppIcon
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
