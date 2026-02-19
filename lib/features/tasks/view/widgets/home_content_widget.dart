import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
          child: Consumer<TasksViewModel>(
            builder: (context, viewModel, child) {
              return HeroHeader(
                avatarAsset: viewModel.avatarAsset,
                heroName: viewModel.heroName,
                level: viewModel.level,
                currentXP: viewModel.currentXP,
                maxXP: viewModel.maxXP,
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

        SizedBox(height: 12.h),

        // Priority Filter
        Consumer<TasksViewModel>(
          builder: (context, viewModel, child) {
            return PriorityFilterSection(
              selectedPriority: viewModel.selectedPriority,
              onPriorityChanged: (priority) {
                viewModel.updatePriorityFilter(priority);
              },
            );
          },
        ),

        SizedBox(height: 12.h),

        // Tabs
        Consumer<TasksViewModel>(
          builder: (context, viewModel, child) {
            return QuestTabs(
              tabController: tabController,
              activeCount: viewModel.filteredActiveQuests.length,
              completedCount: viewModel.filteredCompletedQuests.length,
            );
          },
        ),

        SizedBox(height: 12.h),

        // Quest List with TabBarView
        Expanded(
          child: Consumer<TasksViewModel>(
            builder: (context, viewModel, child) {
              return TabBarView(
                controller: tabController,
                children: [
                  // Active Quests Tab
                  QuestListView(
                    quests: viewModel.filteredActiveQuests,
                    isActiveTab: true,
                    hasFilters: viewModel.hasActiveFilters,
                    onToggleComplete: onQuestToggle,
                    onTap: onQuestTap,
                  ),
                  
                  // Completed Quests Tab
                  QuestListView(
                    quests: viewModel.filteredCompletedQuests,
                    isActiveTab: false,
                    hasFilters: viewModel.hasActiveFilters,
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
