import 'package:epicquests/core/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/pomodoro_viewmodel.dart';
import '../widgets/pomodoro_circular_timer.dart';
import '../widgets/pomodoro_controls.dart';
import '../widgets/pomodoro_session_dots.dart';
import '../widgets/pomodoro_setting_row.dart';

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
                PomodoroSessionDots(
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
                  child: PomodoroCircularTimer(
                    progress: vm.progress,
                    formattedTime: vm.formattedTime,
                    phase: vm.phase,
                  ),
                ),

                // ─── Controls ───────────────────────────
                PomodoroControls(
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
                        PomodoroSettingRow(
                          label: 'Focus (min)',
                          value: work,
                          min: 1,
                          max: 120,
                          onChanged: (v) => setState(() => work = v),
                        ),
                        PomodoroSettingRow(
                          label: 'Short Break',
                          value: shortB,
                          min: 1,
                          max: 30,
                          onChanged: (v) => setState(() => shortB = v),
                        ),
                        PomodoroSettingRow(
                          label: 'Long Break',
                          value: longB,
                          min: 5,
                          max: 60,
                          onChanged: (v) => setState(() => longB = v),
                        ),
                        PomodoroSettingRow(
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
                  decoration: const BoxDecoration(
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
