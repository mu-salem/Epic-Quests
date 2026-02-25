import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/hero_profile.dart';
import '../../../tasks/model/recurring_quest.dart';
import '../../viewmodel/recurring_viewmodel.dart';
import '../widgets/bottom_sheets/add_recurring_quest_bottom_sheet.dart';

class RecurringQuestScreen extends StatefulWidget {
  final HeroProfile hero;

  const RecurringQuestScreen({super.key, required this.hero});

  @override
  State<RecurringQuestScreen> createState() => _RecurringQuestScreenState();
}

class _RecurringQuestScreenState extends State<RecurringQuestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecurringViewModel>().loadQuests(widget.hero.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text(
          '[ RECURRING QUESTS ]',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 8.sp,
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddRecurringDialog(context),
          ),
        ],
      ),
      body: Consumer<RecurringViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.quests.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Text(
                vm.error!,
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 16.sp,
                  color: AppColors.error,
                ),
              ),
            );
          }

          if (vm.quests.isEmpty) {
            return _EmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: vm.quests.length,
            itemBuilder: (context, i) {
              final quest = vm.quests[i];
              return _RecurringQuestTile(
                quest: quest,
                onToggle: () => vm.toggleActive(quest.id, widget.hero.id),
                onDelete: () =>
                    _deleteQuest(context, vm, quest.id, widget.hero.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteQuest(
    BuildContext context,
    RecurringViewModel vm,
    String id,
    String heroId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSoft,
        title: Text(
          'Delete recurring quest?',
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 18.sp,
            color: AppColors.error,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 6.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'DELETE',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 6.sp,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await vm.deleteQuest(id, heroId);
    }
  }

  Future<void> _showAddRecurringDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddRecurringQuestBottomSheet(heroId: widget.hero.id),
    );
  }
}

class _RecurringQuestTile extends StatelessWidget {
  final RecurringQuest quest;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _RecurringQuestTile({
    required this.quest,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: quest.isActive
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          _getRecurrenceIcon(quest.recurrenceType, width: 24.w, height: 24.h),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 7.sp,
                    color: quest.isActive
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  quest.recurrenceType.label,
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 12.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: quest.isActive,
            onChanged: (_) => onToggle(),
            activeThumbColor: AppColors.primary,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 18.r,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _getRecurrenceIcon(
    RecurrenceType type, {
    double? width,
    double? height,
  }) {
    switch (type) {
      case RecurrenceType.daily:
        return AppIcons.homeQuest(width: width, height: height);
      case RecurrenceType.weekly:
        return AppIcons.weeklyQuestCalendar(width: width, height: height);
      case RecurrenceType.monthly:
        return AppIcons.monthlyCalendar(width: width, height: height);
      case RecurrenceType.custom:
        return AppIcons.questScroll(width: width, height: height);
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔄', style: TextStyle(fontSize: 48.sp)),
          SizedBox(height: 12.h),
          Text(
            'NO RECURRING QUESTS',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 7.sp,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap + to add recurring quests',
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
