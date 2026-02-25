import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/spacing_widgets.dart';
import '../../model/quest.dart';
import '../../viewmodel/tasks_viewmodel.dart';
import '../widgets/hero_header.dart';
import '../widgets/priority_filter_chip.dart';
import '../widgets/quest_list_view.dart';
import '../widgets/quest_search_bar.dart';
import '../widgets/quest_tabs.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({
    super.key,
    required this.tabController,
    required this.searchController,
    required this.onSearchChanged,
    required this.onQuestToggle,
    required this.onQuestTap,
    this.onAvatarTap,
  });

  final TabController tabController;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final void Function(String questId) onQuestToggle;
  final void Function(Quest quest) onQuestTap;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero Header
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
          child: Selector<TasksViewModel, (String, String, int, int, int)>(
            selector: (_, vm) =>
                (vm.avatarAsset, vm.heroName, vm.level, vm.currentXP, vm.maxXP),
            builder: (context, data, child) {
              return HeroHeader(
                avatarAsset: data.$1,
                heroName: data.$2,
                level: data.$3,
                currentXP: data.$4,
                maxXP: data.$5,
                onTap: onAvatarTap,
              );
            },
          ),
        ),

        // Search Bar
        QuestSearchBar(
          controller: searchController,
          onChanged: onSearchChanged,
        ),

        HeightSpacer(12),

        // Priority Filter
        Selector<TasksViewModel, QuestPriority?>(
          selector: (_, vm) => vm.selectedPriority,
          builder: (context, selectedPriority, child) {
            return PriorityFilterSection(
              selectedPriority: selectedPriority,
              onPriorityChanged: (priority) {
                context.read<TasksViewModel>().updatePriorityFilter(priority);
              },
            );
          },
        ),

        HeightSpacer(12),

        // Tabs
        Selector<TasksViewModel, (int, int)>(
          selector: (_, vm) => (
            vm.filteredActiveQuests.length,
            vm.filteredCompletedQuests.length,
          ),
          builder: (context, data, child) {
            return QuestTabs(
              tabController: tabController,
              activeCount: data.$1,
              completedCount: data.$2,
            );
          },
        ),

        HeightSpacer(12),

        // Quest List with TabBarView
        Expanded(
          child: Selector<TasksViewModel, (List<Quest>, List<Quest>, bool)>(
            selector: (_, vm) => (
              vm.filteredActiveQuests,
              vm.filteredCompletedQuests,
              vm.hasActiveFilters,
            ),
            builder: (context, data, child) {
              return TabBarView(
                controller: tabController,
                children: [
                  // Active Quests Tab
                  QuestListView(
                    quests: data.$1,
                    isActiveTab: true,
                    hasFilters: data.$3,
                    onToggleComplete: onQuestToggle,
                    onTap: onQuestTap,
                  ),

                  // Completed Quests Tab
                  QuestListView(
                    quests: data.$2,
                    isActiveTab: false,
                    hasFilters: data.$3,
                    onToggleComplete: onQuestToggle,
                    onTap: onQuestTap,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
