import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class PomodoroControls extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const PomodoroControls({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset
        _CtrlBtn(
          icon: Icons.replay,
          color: AppColors.textMuted,
          onTap: onReset,
          size: 20.r,
        ),
        SizedBox(width: 24.w),

        // Play/Pause main button
        GestureDetector(
          onTap: isRunning ? onPause : (isPaused ? onResume : onStart),
          child: Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.5),
            ),
            child: Icon(
              isRunning ? Icons.pause : Icons.play_arrow,
              color: AppColors.primary,
              size: 36.r,
            ),
          ),
        ),
        SizedBox(width: 24.w),

        // Skip
        _CtrlBtn(
          icon: Icons.skip_next,
          color: AppColors.textMuted,
          onTap: onSkip,
          size: 20.r,
        ),
      ],
    );
  }
}

class _CtrlBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _CtrlBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
