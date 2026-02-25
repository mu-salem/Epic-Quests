import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/quest.dart';
import '../../viewmodel/calendar_viewmodel.dart';

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

                SliverToBoxAdapter(child: _buildCalendar(vm)),

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
                          return _QuestDayTile(quest: quest);
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

  Widget _buildCalendar(CalendarViewModel vm) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: TableCalendar<Quest>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: vm.focusedDay,
        selectedDayPredicate: (day) => isSameDay(vm.selectedDay, day),
        onDaySelected: vm.onDaySelected,
        onPageChanged: vm.onPageChanged,
        eventLoader: vm.getEventsForDay,
        weekendDays: const [DateTime.friday, DateTime.saturday],
        rowHeight: 60.h,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          markersAlignment: Alignment.bottomCenter,
          markerDecoration: const BoxDecoration(
            color: AppColors.priorityHigh,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10.sp,
            color: AppColors.textPrimary,
          ),
          weekendTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10.sp,
            color: AppColors.primary,
          ),
          outsideTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10.sp,
            color: AppColors.textMuted,
          ),
          selectedTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10.sp,
            color: AppColors.backgroundDark,
          ),
          todayTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10.sp,
            color: AppColors.accent,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 12.sp,
            color: AppColors.accent,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.primary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 8.sp,
            color: AppColors.textSecondary,
          ),
          weekendStyle: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 8.sp,
            color: AppColors.primary,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final density = vm.densityForDay(day);
            if (density == 0) return null;
            return Container(
              margin: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: density * 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: density * 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 10.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuestDayTile extends StatelessWidget {
  final Quest quest;

  const _QuestDayTile({required this.quest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/quest/${quest.id}', extra: quest),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundSoft,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: quest.isCompleted
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            _getPriorityIcon(quest.priority, width: 18.w, height: 18.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                quest.title,
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 22.sp,
                  color: quest.isCompleted
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  decoration: quest.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            if (quest.isCompleted)
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
          ],
        ),
      ),
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
