import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/app_icons.dart';

class PomodoroSessionDots extends StatelessWidget {
  final int completed;
  final int target;

  const PomodoroSessionDots({
    super.key,
    required this.completed,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(target, (i) {
        final currentMod = completed % target == 0 && completed > 0
            ? target
            : completed % target;
        final isDone = i < currentMod;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isDone ? 1.0 : 0.25,
            child: AppIcons.pomodoroSession(width: 18.w, height: 18.h),
          ),
        );
      }),
    );
  }
}
