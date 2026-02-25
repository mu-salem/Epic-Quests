import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(color: AppColors.primaryTint70),
    );
  }
}
