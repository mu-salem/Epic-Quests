import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Base
  static const Color primary = Color(0xFF8E6BA8);

  // Primary Tint variations (lighter)
  static const Color primaryTint90 = Color(0xFFF0E8F5);
  static const Color primaryTint70 = Color(0xFFD6C2E3);
  static const Color primaryTint50 = Color(0xFFB99DCE);
  static const Color primaryTint30 = Color(0xFF9F78B8);

  // Primary Shade variations (darker)
  static const Color primaryShade30 = Color(0xFF75528F);
  static const Color primaryShade50 = Color(0xFF5C3D74);
  static const Color primaryShade70 = Color(0xFF432A58);
  static const Color primaryShade90 = Color(0xFF2B183D);

  // ================================
  // Background
  // ================================
  static const Color backgroundDark = Color(0xFF2A2733);
  static const Color backgroundSoft = Color(0xFF343140);
  static const Color backgroundLight = Color(0xFFF5EFE6);

  // ================================
  // Panels / Cards
  // ================================
  static const Color panelDark = Color(0xFF343140);
  static const Color panelLight = Color(0xFFE7C9A5);

  // ================================
  // Text
  // ================================
  static const Color textPrimary = Color(0xFFF5EFE6);
  static const Color textSecondary = Color(0xFFD6CFC5);
  static const Color textMuted = Color(0xFFB3ACA3);

  // ================================
  // Priority Colors
  // ================================
  static const Color priorityLow = Color(0xFF7FB069); // Green
  static const Color priorityMedium = Color(0xFFE6B566); // Yellow
  static const Color priorityHigh = Color(0xFFD16D6A); // Red

  // ================================
  // Accent Colors
  // ================================
  static const Color indigo = Color(0xFF4E5A9B);

  // ================================
  // Neutral
  // ================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color border = Color(0xFF4A4658);
  static const Color transparent = Color(0x00000000);

  // ================================
  // States
  // ================================
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  // ================================
  // Onboarding Accent (Retro Gold)
  // ================================
  static const Color accent = Color(0xFFE7C9A5);
  static const Color accentDark = Color(0xFFC2A178);

  // ================================
  // Premium Gradients
  // ================================
  static const LinearGradient mysticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryShade50],
  );

  static const LinearGradient heroicGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [priorityHigh, primaryShade70],
  );

  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
  );
}
