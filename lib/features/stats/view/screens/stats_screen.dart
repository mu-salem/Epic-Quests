import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/stats_viewmodel.dart';
import '../widgets/pixel_bar_chart.dart';
import '../widgets/priority_distribution.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late StatsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = StatsViewModel();
    _vm.loadData();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Consumer<StatsViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final avgTime = vm.averageCompletionTime;
            final avgStr = avgTime != null
                ? avgTime.inHours > 0
                      ? '${avgTime.inHours}h ${avgTime.inMinutes.remainder(60)}m'
                      : '${avgTime.inMinutes}m'
                : 'N/A';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.backgroundDark,
                  floating: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.statsBarChart(width: 20.w, height: 20.h),
                      SizedBox(width: 8.w),
                      Text(
                        '[ STATISTICS ]',
                        style: TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 10.sp,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                ),

                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                    delegate: SliverChildListDelegate([
                      StatCard(
                        iconWidget: AppIcons.completedQuest(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'Total Done',
                        value: '${vm.totalCompleted}',
                        color: AppColors.priorityLow,
                        onTap: () => context.go('/home'),
                      ),
                      StatCard(
                        iconWidget: AppIcons.rewardMedal(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'Completion',
                        value: '${(vm.completionRate * 100).round()}%',
                        color: AppColors.primary,
                        onTap: () => context.go('/home'),
                      ),
                      StatCard(
                        iconWidget: AppIcons.weeklyQuestCalendar(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'This Week',
                        value: '${vm.completedThisWeek}',
                        color: AppColors.indigo,
                        onTap: () => context.go('/calendar'),
                      ),
                      StatCard(
                        iconWidget: AppIcons.monthlyCalendar(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'This Month',
                        value: '${vm.completedThisMonth}',
                        color: AppColors.accent,
                        onTap: () => context.go('/calendar'),
                      ),
                      StatCard(
                        iconWidget: AppIcons.timeSpentHourglass(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'Avg Time',
                        value: avgStr,
                        color: AppColors.priorityMedium,
                        onTap: () {}, // No specific screen for this yet
                      ),
                      StatCard(
                        iconWidget: AppIcons.questChecklist(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'Active',
                        value: '${vm.totalActive}',
                        color: AppColors.priorityHigh,
                        onTap: () => context.go('/home'), // Navigate to Home
                      ),
                    ]),
                  ),
                ),

                // ─── 7-Day Bar Chart ─────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[ LAST 7 DAYS ]',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 7.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        PixelBarChart(dailyCounts: vm.last7DaysCounts),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                // ─── Priority Distribution ────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[ PRIORITY BREAKDOWN ]',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 7.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        PriorityDistribution(
                          distribution: vm.priorityDistribution,
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 120.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
