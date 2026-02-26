import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/calendar_viewmodel.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/quest_day_tile.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CalendarViewModel();
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
        body: Consumer<CalendarViewModel>(
          builder: (context, vm, _) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.backgroundDark,
                  floating: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.monthlyCalendar(width: 20.w, height: 20.h),
                      SizedBox(width: 8.w),
                      Text(
                        '[ QUEST CALENDAR ]',
                        style: TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 8.sp,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                ),

                SliverToBoxAdapter(child: CalendarWidget(vm: vm)),

                SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      '[ ${DateFormat('MMM d, yyyy').format(vm.selectedDay).toUpperCase()} ]',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 7.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                vm.selectedDayQuests.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Center(
                            child: Text(
                              'No quests on this day',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 16.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final quest = vm.selectedDayQuests[index];
                          return QuestDayTile(
                            quest: quest,
                            onTap: () => context.push(
                              '/quest/${quest.id}',
                              extra: quest,
                            ),
                          );
                        }, childCount: vm.selectedDayQuests.length),
                      ),

                SliverToBoxAdapter(child: SizedBox(height: 80.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
