import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';

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
            shadowColor: AppColors.error.withOpacity(0.3),
          ),
          SizedBox(height: 12.h),
        ],

        // Save Button
        PrimaryButton(
          text: isEditing ? 'UPDATE QUEST' : 'CREATE QUEST',
          width: double.infinity,
          onPressed: onSave,
        ),

        SizedBox(height: 12.h),
      ],
    );
  }
}
