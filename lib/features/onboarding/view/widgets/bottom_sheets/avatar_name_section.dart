import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// Section for custom avatar name with checkbox toggle
class AvatarNameSection extends StatelessWidget {
  final bool useCustomName;
  final ValueChanged<bool> onUseCustomNameChanged;
  final TextEditingController nameController;
  final String defaultName;

  const AvatarNameSection({
    super.key,
    required this.useCustomName,
    required this.onUseCustomNameChanged,
    required this.nameController,
    required this.defaultName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Name Toggle
        Row(
          children: [
            Checkbox(
              value: useCustomName,
              onChanged: (value) => onUseCustomNameChanged(value ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.accent;
                }
                return AppColors.panelDark;
              }),
              side: const BorderSide(color: AppColors.border, width: 2),
            ),
            Text(
              'Use custom name',
              style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),

        HeightSpacer(12),

        // Custom name TextField or default name display
        if (useCustomName)
          TextField(
            controller: nameController,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter avatar name',
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
          )
        else
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.panelDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: AppColors.textMuted, size: 20.sp),
                WidthSpacer(8),
                Text(
                  'Default name: $defaultName',
                  style: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
