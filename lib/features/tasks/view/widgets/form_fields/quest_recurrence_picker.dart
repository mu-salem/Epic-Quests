import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/app_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/spacing_widgets.dart';
import '../../../model/recurring_quest.dart';

class QuestRecurrencePicker extends StatelessWidget {
  const QuestRecurrencePicker({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  final RecurrenceType? selectedType;
  final ValueChanged<RecurrenceType?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat (Optional)',
          style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
        ),
        HeightSpacer(8),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildRecurrenceOption(null, 'None'),
            ...RecurrenceType.values
                .where((t) => t != RecurrenceType.custom)
                .map((type) {
                  return _buildRecurrenceOption(type, type.label);
                }),
          ],
        ),
      ],
    );
  }

  Widget _buildRecurrenceOption(RecurrenceType? type, String label) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.panelDark,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (type != null) ...[
              _getRecurrenceIcon(type.pixelIcon, width: 14.w, height: 14.h),
              WidthSpacer(6),
            ] else ...[
              Icon(
                Icons.do_not_disturb_alt,
                size: 14.w,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              WidthSpacer(6),
            ],
            Text(
              label,
              style: AppTextStyles.bodyM.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRecurrenceIcon(
    String iconPath, {
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) {
    if (iconPath.contains('daily')) {
      // Assuming daily uses urgentQuestIcon or similar, wait, recurring quests usually use calendar icons
      return AppIcons.monthlyCalendar(
        width: width,
        height: height,
        colorFilter: colorFilter,
      );
    } else if (iconPath.contains('weekly')) {
      return AppIcons.weeklyQuestCalendar(
        width: width,
        height: height,
        colorFilter: colorFilter,
      );
    } else if (iconPath.contains('monthly')) {
      return AppIcons.monthlyCalendar(
        width: width,
        height: height,
        colorFilter: colorFilter,
      );
    }
    // Fallback
    return AppIcons.monthlyCalendar(
      width: width,
      height: height,
      colorFilter: colorFilter,
    );
  }
}
