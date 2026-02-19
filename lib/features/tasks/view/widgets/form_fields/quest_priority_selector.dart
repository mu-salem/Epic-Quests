import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
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
                    color: isSelected ? AppColors.primary : AppColors.panelDark,
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
                      Text(
                        priority.icon,
                        style: TextStyle(fontSize: 20.sp),
                      ),
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
}
