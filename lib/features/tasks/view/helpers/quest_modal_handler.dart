import 'package:flutter/material.dart';

import '../../model/quest.dart';
import '../../viewmodel/tasks_viewmodel.dart';
import '../widgets/add_quest_bottom_sheet.dart';

class QuestModalHandler {
  /// Show add quest modal
  static Future<void> showAddQuestModal({
    required BuildContext context,
    required TasksViewModel viewModel,
  }) async {
    final result = await showModalBottomSheet<Quest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddQuestBottomSheet(),
    );

    if (result != null) {
      await viewModel.addQuest(result);
    }
  }

  /// Show edit quest modal
  static Future<void> showEditQuestModal({
    required BuildContext context,
    required TasksViewModel viewModel,
    required Quest quest,
  }) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddQuestBottomSheet(questToEdit: quest),
    );

    if (result != null) {
      if (result == 'delete') {
        // Delete the quest
        await viewModel.deleteQuest(quest.id);
      } else if (result is Quest) {
        // Update the quest
        await viewModel.updateQuest(result);
      }
    }
  }
}
