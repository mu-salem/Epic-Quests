import 'package:epicquests/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base text color (retro parchment style)
  static const Color _baseTextColor = AppColors.primaryTint90;

  // ---------- Base styles ----------
  static const TextStyle _headingBase = TextStyle(
    fontFamily: 'PressStart2P',
    color: _baseTextColor,
    height: 1.3,
  );

  static const TextStyle _bodyBase = TextStyle(
    fontFamily: 'VT323',
    color: _baseTextColor,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // ---------- Headings (Game / Pixel) ----------
  static TextStyle get h1 => _headingBase.copyWith(fontSize: 26);
  static TextStyle get h2 => _headingBase.copyWith(fontSize: 20);
  static TextStyle get h3 => _headingBase.copyWith(fontSize: 16);
  static TextStyle get h4 => _headingBase.copyWith(fontSize: 13);

  // ---------- Body ----------
  static TextStyle get bodyXL => _bodyBase.copyWith(fontSize: 26);
  static TextStyle get bodyL => _bodyBase.copyWith(fontSize: 22);
  static TextStyle get bodyM => _bodyBase.copyWith(fontSize: 20);
  static TextStyle get bodyS => _bodyBase.copyWith(fontSize: 18);

  // ---------- Helpers ----------
  static TextStyle get caption => _bodyBase.copyWith(
        fontSize: 16,
        color: _baseTextColor.withValues(alpha: 0.7),
      );

  static TextStyle get hint => _bodyBase.copyWith(
        fontSize: 18,
        color: _baseTextColor.withValues(alpha: 0.5),
      );

  static TextStyle get button => _headingBase.copyWith(
        fontSize: 14,
        color: AppColors.backgroundDark,
        height: 1.0,
      );

  static TextStyle get badge => _headingBase.copyWith(
        fontSize: 10,
        height: 1.0,
      );

  // ---------- Quest Card ----------
  static TextStyle get questTitle => _headingBase.copyWith(fontSize: 14);

  static TextStyle get questDesc => _bodyBase.copyWith(
        fontSize: 20,
        color: _baseTextColor.withValues(alpha: 0.85),
      );

  static TextStyle get questMeta => _bodyBase.copyWith(
        fontSize: 18,
        color: _baseTextColor.withValues(alpha: 0.65),
      );
}
