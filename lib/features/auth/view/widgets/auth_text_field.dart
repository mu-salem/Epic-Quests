import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Game-styled text field for auth forms
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        HeightSpacer(8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            counterText: '',
            filled: true,
            fillColor: AppColors.backgroundSoft,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: AppColors.border,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: AppColors.border,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null) ...[
          HeightSpacer(6),
          Text(
            errorText!,
            style: AppTextStyles.bodyS.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
