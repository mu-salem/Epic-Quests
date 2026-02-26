import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/spacing_widgets.dart';

class ReadonlyEmailField extends StatelessWidget {
  final String email;

  const ReadonlyEmailField({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.email_outlined, color: AppColors.textMuted),
          WidthSpacer(12),
          Expanded(
            child: Text(
              email,
              style: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
            ),
          ),
          const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 16),
        ],
      ),
    );
  }
}
