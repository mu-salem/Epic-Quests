import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Quest Empty State Widget
/// 
/// Displays an empty state when no quests are available
class QuestEmptyState extends StatelessWidget {
  const QuestEmptyState({
    super.key,
    required this.isActiveTab,
    this.hasFilters = false,
  });

  final bool isActiveTab;
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    String message;
    if (hasFilters) {
      message = 'Try adjusting your filters';
    } else if (isActiveTab) {
      message = 'No active quests!\nStart your adventure by\ncreating a new quest!';
    } else {
      message = 'No completed quests yet!\nComplete some quests to see\nthem here!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isActiveTab ? '📜' : '✅',
            style: TextStyle(fontSize: 64.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            isActiveTab ? 'No Active Quests' : 'No Completed Quests',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
