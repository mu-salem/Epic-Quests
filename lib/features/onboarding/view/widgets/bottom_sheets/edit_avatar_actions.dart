import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import '../common/delete_avatar_button.dart';

class EditAvatarActions extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const EditAvatarActions({
    super.key,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 10.h,
        bottom: 20.h + bottomPadding + bottomSafeArea,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(top: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Update Button
          PrimaryButton(
            text: 'UPDATE AVATAR',
            width: double.infinity,
            onPressed: onUpdate,
            backgroundColor: AppColors.panelLight,
            borderColor: AppColors.accent,
            shadowColor: AppColors.accent,
            textColor: AppColors.backgroundDark,
          ),

          HeightSpacer(12),

          // Delete Button
          DeleteAvatarButton(onPressed: onDelete),
        ],
      ),
    );
  }
}
