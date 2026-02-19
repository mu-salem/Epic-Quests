import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// TextField for avatar description
class AvatarDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const AvatarDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION (OPTIONAL)',
          style: AppTextStyles.bodyS.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        HeightSpacer(8),
        TextField(
          controller: controller,
          maxLines: 3,
          style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., For work tasks, Study avatar, etc.',
            hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
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
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
