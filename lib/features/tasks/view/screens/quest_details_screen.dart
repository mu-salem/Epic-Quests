import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/quest.dart';
import '../widgets/quest_action_button.dart';
import '../widgets/quest_info_row.dart';
import '../widgets/quest_section_card.dart';
import '../widgets/quest_status_badge.dart';

class QuestDetailsScreen extends StatelessWidget {
  final Quest quest;

  const QuestDetailsScreen({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ─────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            expandedHeight: 140.h,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryShade70,
                      AppColors.backgroundDark,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      _getPriorityIcon(
                        quest.priority,
                        width: 64.w,
                        height: 64.h,
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          quest.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 14.sp,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── Status Badge ─────────────────────────
                Row(
                  children: [
                    QuestStatusBadge(
                      text: quest.isCompleted ? 'COMPLETED' : 'ACTIVE',
                      color: quest.isCompleted
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    QuestStatusBadge(
                      text: quest.priority.label.toUpperCase(),
                      color: _priorityColor(quest.priority),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ─── Description Card ─────────────────────
                QuestSectionCard(
                  title: 'DESCRIPTION',
                  child: Text(
                    quest.description?.isEmpty ?? true
                        ? 'No description provided.'
                        : quest.description!,
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 16.sp,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // ─── Dates Card ───────────────────────────
                QuestSectionCard(
                  title: 'TIMELINE',
                  child: Column(
                    children: [
                      QuestInfoRow(
                        iconWidget: AppIcons.homeQuest(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'Created',
                        value: DateFormat(
                          'MMM d, yyyy · h:mm a',
                        ).format(quest.createdAt),
                      ),
                      if (quest.deadline != null) ...[
                        SizedBox(height: 12.h),
                        QuestInfoRow(
                          iconWidget: AppIcons.urgentQuest(
                            width: 20.w,
                            height: 20.h,
                          ),
                          label: 'Deadline',
                          value: DateFormat(
                            'MMM d, yyyy · h:mm a',
                          ).format(quest.deadline!),
                          valueColor: _deadlineColor(quest.deadline!),
                        ),
                      ],
                      if (quest.completedAt != null) ...[
                        SizedBox(height: 12.h),
                        QuestInfoRow(
                          iconWidget: AppIcons.completedQuest(
                            width: 20.w,
                            height: 20.h,
                          ),
                          label: 'Completed',
                          value: DateFormat(
                            'MMM d, yyyy · h:mm a',
                          ).format(quest.completedAt!),
                          valueColor: AppColors.success,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // ─── XP and Pomodoro Card ─────────────────
                QuestSectionCard(
                  title: 'PROGRESS',
                  child: Column(
                    children: [
                      QuestInfoRow(
                        iconWidget: AppIcons.rewardMedal(
                          width: 20.w,
                          height: 20.h,
                        ),
                        label: 'XP Reward',
                        value: '${quest.xpReward} XP',
                        valueColor: AppColors.accent,
                      ),
                      if (quest.pomodorosCompleted > 0) ...[
                        SizedBox(height: 12.h),
                        QuestInfoRow(
                          iconWidget: AppIcons.pomodoroSession(
                            width: 20.w,
                            height: 20.h,
                          ),
                          label: 'Pomodoros',
                          value: '${quest.pomodorosCompleted} sessions',
                          valueColor: AppColors.priorityHigh,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // ─── Actions ─────────────────────────────
                if (!quest.isCompleted) ...[
                  // Start Pomodoro
                  QuestActionButton(
                    iconWidget: AppIcons.pomodoroTimer(
                      width: 24.w,
                      height: 24.h,
                    ),
                    text: 'START POMODORO',
                    color: AppColors.priorityHigh,
                    onTap: () => context.push(
                      '${AppRouter.pomodoro}?questId=${quest.id}',
                      extra: quest,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Back
                QuestActionButton(
                  iconWidget: AppIcons.questScroll(width: 24.w, height: 24.h),
                  text: 'BACK TO QUESTS',
                  color: AppColors.primary,
                  onTap: () => context.pop(),
                ),

                SizedBox(height: 80.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(QuestPriority p) {
    switch (p) {
      case QuestPriority.low:
        return AppColors.priorityLow;
      case QuestPriority.medium:
        return AppColors.priorityMedium;
      case QuestPriority.high:
        return AppColors.priorityHigh;
    }
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

  Color _deadlineColor(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return AppColors.error;
    if (diff.inHours < 24) return AppColors.warning;
    return AppColors.textSecondary;
  }
}
