import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/spacing_widgets.dart';

/// Description input field for quest form
class QuestDescriptionField extends StatelessWidget {
  const QuestDescriptionField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        HeightSpacer(8),
        TextFormField(
          controller: controller,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textPrimary,
          ),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Quest details...',
            hintStyle: AppTextStyles.hint,
            filled: true,
            fillColor: AppColors.panelDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }
}
