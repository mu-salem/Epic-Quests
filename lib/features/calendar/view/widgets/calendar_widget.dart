import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/quest.dart';
import '../../viewmodel/calendar_viewmodel.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarViewModel vm;

  const CalendarWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
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
