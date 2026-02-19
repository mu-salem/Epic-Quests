import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';

/// Grid of avatar templates with 3-column layout
class AvatarTemplateGrid extends StatelessWidget {
  final List<AvatarTemplate> templates;
  final int selectedIndex;
  final ValueChanged<int> onTemplateSelected;

  const AvatarTemplateGrid({
    super.key,
    required this.templates,
    required this.selectedIndex,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final spacing = 12.w;
        final cardWidth = (availableWidth - (spacing * 2)) / 3;
        final cardHeight = cardWidth * 0.95;

        return Wrap(
          spacing: spacing,
          runSpacing: 12.h,
          children: List.generate(
            templates.length,
            (index) {
              final template = templates[index];
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onTemplateSelected(index),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: AppColors.panelDark,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.border,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Image.asset(
                            template.asset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      HeightSpacer(4),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                        child: Text(
                          template.name,
                          style: AppTextStyles.bodyS.copyWith(
                            color: isSelected ? AppColors.accent : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
