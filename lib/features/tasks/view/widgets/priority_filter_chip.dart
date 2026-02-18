import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/quest.dart';

/// Priority Filter Chip
/// 
/// Displays a filter chip for quest priority filtering
class PriorityFilterChip extends StatelessWidget {
  const PriorityFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.panelDark,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryTint70 : AppColors.border,
            width: 2.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(
                icon!,
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: AppTextStyles.h4.copyWith(
                fontSize: 15.sp,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Priority Filter Section
/// 
/// Shows all priority filter options
class PriorityFilterSection extends StatelessWidget {
  const PriorityFilterSection({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  final QuestPriority? selectedPriority;
  final ValueChanged<QuestPriority?> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          PriorityFilterChip(
            label: 'All',
            isSelected: selectedPriority == null,
            onTap: () => onPriorityChanged(null),
          ),
          PriorityFilterChip(
            label: 'Low',
            icon: QuestPriority.low.icon,
            isSelected: selectedPriority == QuestPriority.low,
            onTap: () => onPriorityChanged(QuestPriority.low),
          ),
          PriorityFilterChip(
            label: 'Medium',
            icon: QuestPriority.medium.icon,
            isSelected: selectedPriority == QuestPriority.medium,
            onTap: () => onPriorityChanged(QuestPriority.medium),
          ),
          PriorityFilterChip(
            label: 'High',
            icon: QuestPriority.high.icon,
            isSelected: selectedPriority == QuestPriority.high,
            onTap: () => onPriorityChanged(QuestPriority.high),
          ),
        ],
      ),
    );
  }
}
