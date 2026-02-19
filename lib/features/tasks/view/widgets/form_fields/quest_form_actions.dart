import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/spacing_widgets.dart';

/// Action buttons for quest form (Delete/Save)
class QuestFormActions extends StatelessWidget {
  const QuestFormActions({
    super.key,
    required this.isEditing,
    required this.onSave,
    required this.onDelete,
  });

  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Delete Button (only in edit mode)
        if (isEditing) ...[
          PrimaryButton(
            text: 'DELETE QUEST',
            width: double.infinity,
            onPressed: onDelete,
            backgroundColor: AppColors.error,
            borderColor: AppColors.error,
            shadowColor: AppColors.error..withValues(alpha: 0.3),
          ),
          HeightSpacer(12),
        ],

        // Save Button
        PrimaryButton(
          text: isEditing ? 'UPDATE QUEST' : 'CREATE QUEST',
          width: double.infinity,
          onPressed: onSave,
        ),

        HeightSpacer(12),
      ],
    );
  }
}
