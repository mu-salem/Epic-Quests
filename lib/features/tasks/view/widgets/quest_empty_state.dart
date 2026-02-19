import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';

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
          HeightSpacer(16),
          Text(
            isActiveTab ? 'No Active Quests' : 'No Completed Quests',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          HeightSpacer(8),
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
