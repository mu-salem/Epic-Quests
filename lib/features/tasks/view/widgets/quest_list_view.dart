import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/quest.dart';
import '../widgets/quest_card.dart';
import '../widgets/quest_empty_state.dart';

/// Quest List Widget
/// 
/// Displays a list of quests with empty state handling
class QuestListView extends StatelessWidget {
  const QuestListView({
    super.key,
    required this.quests,
    required this.isActiveTab,
    required this.hasFilters,
    required this.onToggleComplete,
    required this.onTap,
  });

  final List<Quest> quests;
  final bool isActiveTab;
  final bool hasFilters;
  final void Function(String questId) onToggleComplete;
  final void Function(Quest quest) onTap;

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return QuestEmptyState(
        isActiveTab: isActiveTab,
        hasFilters: hasFilters,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100.h, top: 8.h),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return QuestCard(
          quest: quest,
          onToggleComplete: () => onToggleComplete(quest.id),
          onTap: () => onTap(quest),
        );
      },
    );
  }
}
