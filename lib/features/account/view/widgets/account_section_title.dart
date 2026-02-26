import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AccountSectionTitle extends StatelessWidget {
  final String title;

  const AccountSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodyS.copyWith(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
