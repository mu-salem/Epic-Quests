import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/stats_viewmodel.dart';
import 'package:intl/intl.dart';

class PixelBarChart extends StatelessWidget {
  final List<DailyCount> dailyCounts;

  const PixelBarChart({super.key, required this.dailyCounts});

  @override
  Widget build(BuildContext context) {
    final maxCount = dailyCounts.fold<int>(
      0,
      (m, d) => d.count > m ? d.count : m,
    );
    final safeMax = maxCount == 0 ? 1 : maxCount;

    return Container(
      height: 140.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dailyCounts.map((d) {
          final frac = d.count / safeMax;
          final isToday = _isToday(d.date);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (d.count > 0)
                    Text(
                      '${d.count}',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 5.sp,
                        color: AppColors.accent,
                      ),
                    ),
                  SizedBox(height: 2.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      height: (80 * frac).h + 4.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isToday
                              ? [AppColors.accent, AppColors.primary]
                              : [
                                  AppColors.primary.withValues(alpha: 0.5),
                                  AppColors.primary,
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                        border: isToday
                            ? Border.all(color: AppColors.accent, width: 1)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('E').format(d.date).substring(0, 1),
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 5.sp,
                      color: isToday ? AppColors.accent : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
