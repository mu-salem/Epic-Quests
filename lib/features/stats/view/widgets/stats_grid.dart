import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/stats_viewmodel.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final StatsViewModel vm;
  final String avgTimeStr;

  const StatsGrid({super.key, required this.vm, required this.avgTimeStr});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildListDelegate([
          StatCard(
            iconWidget: AppIcons.completedQuest(width: 20.w, height: 20.h),
            label: 'Total Done',
            value: '${vm.totalCompleted}',
            color: AppColors.priorityLow,
            onTap: () => context.go('/home'),
          ),
          StatCard(
            iconWidget: AppIcons.rewardMedal(width: 20.w, height: 20.h),
            label: 'Completion',
            value: '${(vm.completionRate * 100).round()}%',
            color: AppColors.primary,
            onTap: () => context.go('/home'),
          ),
          StatCard(
            iconWidget: AppIcons.weeklyQuestCalendar(width: 20.w, height: 20.h),
            label: 'This Week',
            value: '${vm.completedThisWeek}',
            color: AppColors.indigo,
            onTap: () => context.go('/calendar'),
          ),
          StatCard(
            iconWidget: AppIcons.monthlyCalendar(width: 20.w, height: 20.h),
            label: 'This Month',
            value: '${vm.completedThisMonth}',
            color: AppColors.accent,
            onTap: () => context.go('/calendar'),
          ),
          StatCard(
            iconWidget: AppIcons.timeSpentHourglass(width: 20.w, height: 20.h),
            label: 'Avg Time',
            value: avgTimeStr,
            color: AppColors.priorityMedium,
            onTap: () {}, // No specific screen for this yet
          ),
          StatCard(
            iconWidget: AppIcons.questChecklist(width: 20.w, height: 20.h),
            label: 'Active',
            value: '${vm.totalActive}',
            color: AppColors.priorityHigh,
            onTap: () => context.go('/home'), // Navigate to Home
          ),
        ]),
      ),
    );
  }
}
