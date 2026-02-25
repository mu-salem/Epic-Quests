import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Link row for auth screens (e.g., "Already have account? Login")
class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
        ),
        WidthSpacer(6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.accent,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
