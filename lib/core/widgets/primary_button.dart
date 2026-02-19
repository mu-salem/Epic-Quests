import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'spacing_widgets.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.showShadow = true,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.icon,
    this.loadingIndicatorColor,
  });

  // Core properties
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  // Styling properties
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  // Shadow properties
  final bool showShadow;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final double? shadowSpreadRadius;

  // Additional properties
  final Widget? icon;
  final Color? loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    
    // Default colors
    final defaultBgColor = backgroundColor ?? AppColors.primary;
    final defaultDisabledBgColor = disabledBackgroundColor ?? AppColors.panelDark;
    final defaultTextColor = textColor ?? AppColors.textPrimary;
    final defaultBorderColor = borderColor ?? (isDisabled ? AppColors.border : AppColors.primary);
    final defaultBorderWidth = borderWidth ?? 3.0;
    final defaultBorderRadius = borderRadius ?? 6.r;
    final defaultPadding = padding ?? EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h);
    
    // Shadow defaults
    final defaultShadowColor = shadowColor ?? AppColors.primary..withValues(alpha: 0.3);
    final defaultShadowBlur = shadowBlurRadius ?? 12.0;
    final defaultShadowSpread = shadowSpreadRadius ?? 2.0;

    Widget buttonChild;
    if (isLoading) {
      buttonChild = SizedBox(
        width: 20.w,
        height: 20.h,
        child: CircularProgressIndicator(
          color: loadingIndicatorColor ?? defaultTextColor,
          strokeWidth: 2,
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          WidthSpacer(8),
          Text(
            text,
            style: (textStyle ?? AppTextStyles.button).copyWith(
              color: defaultTextColor,
            ),
          ),
        ],
      );
    } else {
      buttonChild = Text(
        text,
        style: (textStyle ?? AppTextStyles.button).copyWith(
          color: defaultTextColor,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          border: Border.all(
            color: defaultBorderColor,
            width: defaultBorderWidth,
          ),
          boxShadow: (showShadow && !isDisabled)
              ? [
                  BoxShadow(
                    color: defaultShadowColor,
                    blurRadius: defaultShadowBlur,
                    spreadRadius: defaultShadowSpread,
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? defaultDisabledBgColor : defaultBgColor,
            foregroundColor: defaultTextColor,
            padding: defaultPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            elevation: 0,
          ),
          child: buttonChild,
        ),
      ),
    );
  }
}
