import 'package:epicquests/core/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/pomodoro_viewmodel.dart';

class PomodoroScreen extends StatefulWidget {
  final String? questId;

  const PomodoroScreen({super.key, this.questId});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  late PomodoroViewModel _vm;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _vm = PomodoroViewModel(questId: widget.questId);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<PomodoroViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundDark,
              leading: IconButton(
                icon: AppIcons.questScroll(width: 32.w, height: 32.h),
                onPressed: () {
                  vm.pause();
                  context.pop();
                },
              ),
              title: Text(
                vm.phaseLabel,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 12.sp,
                  color: _phaseColor(vm.phase),
                ),
              ),
              centerTitle: true,
              actions: [
                // Settings button
                IconButton(
                  icon: AppIcons.settingsGear(width: 32.w, height: 32.h),
                  onPressed: () => _showSettings(context, vm),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ─── Session Dots ───────────────────────
                _SessionDots(
                  completed: vm.sessionsCompleted,
                  target: vm.sessionsBeforeLongBreak,
                ),

                // ─── Circular Timer ─────────────────────
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final scale = vm.isRunning ? _pulseAnimation.value : 1.0;
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: _CircularTimer(
                    progress: vm.progress,
                    formattedTime: vm.formattedTime,
                    phase: vm.phase,
                  ),
                ),

                // ─── Controls ───────────────────────────
                _Controls(
                  isRunning: vm.isRunning,
                  isPaused: vm.isPaused,
                  onStart: vm.start,
                  onPause: vm.pause,
                  onResume: vm.resume,
                  onReset: vm.reset,
                  onSkip: vm.skipPhase,
                ),

                // ─── Info ────────────────────────────────
                Text(
                  '${vm.sessionsCompleted} pomodoro${vm.sessionsCompleted == 1 ? '' : 's'} completed',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 20.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _phaseColor(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return AppColors.priorityHigh;
      case PomodoroPhase.shortBreak:
        return AppColors.priorityLow;
      case PomodoroPhase.longBreak:
        return AppColors.primary;
    }
  }

  Future<void> _showSettings(BuildContext context, PomodoroViewModel vm) async {
    int work = vm.workDuration;
    int shortB = vm.shortBreakDuration;
    int longB = vm.longBreakDuration;
    int sessions = vm.sessionsBeforeLongBreak;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSoft,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                  child: Text(
                    '[ POMODORO SETTINGS ]',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 7.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        _SettingRow(
                          label: 'Focus (min)',
                          value: work,
                          min: 1,
                          max: 120,
                          onChanged: (v) => setState(() => work = v),
                        ),
                        _SettingRow(
                          label: 'Short Break',
                          value: shortB,
                          min: 1,
                          max: 30,
                          onChanged: (v) => setState(() => shortB = v),
                        ),
                        _SettingRow(
                          label: 'Long Break',
                          value: longB,
                          min: 5,
                          max: 60,
                          onChanged: (v) => setState(() => longB = v),
                        ),
                        _SettingRow(
                          label: 'Sessions',
                          value: sessions,
                          min: 2,
                          max: 8,
                          onChanged: (v) => setState(() => sessions = v),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 10.h,
                    bottom: MediaQuery.of(ctx).padding.bottom + 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSoft,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      vm.updateConfig(
                        work: work,
                        shortBreak: shortB,
                        longBreak: longB,
                        sessions: sessions,
                      );
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 8.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularTimer extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final PomodoroPhase phase;

  const _CircularTimer({
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

class _SessionDots extends StatelessWidget {
  final int completed;
  final int target;

  const _SessionDots({required this.completed, required this.target});

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

class _Controls extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const _Controls({
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

class _SettingRow extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _SettingRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove, color: AppColors.primary),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 40.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 9.sp,
                color: AppColors.accent,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
