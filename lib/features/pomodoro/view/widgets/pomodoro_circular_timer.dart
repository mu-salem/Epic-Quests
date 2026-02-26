import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../viewmodel/pomodoro_viewmodel.dart';

class PomodoroCircularTimer extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final PomodoroPhase phase;

  const PomodoroCircularTimer({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.phase,
  });

  Color get _color {
    switch (phase) {
      case PomodoroPhase.work:
        return AppColors.priorityHigh;
      case PomodoroPhase.shortBreak:
        return AppColors.priorityLow;
      case PomodoroPhase.longBreak:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.w,
      height: 240.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10.w,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 36.sp,
                  color: _color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                phase == PomodoroPhase.work ? 'FOCUS TIME' : 'BREAK TIME',
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 18.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
