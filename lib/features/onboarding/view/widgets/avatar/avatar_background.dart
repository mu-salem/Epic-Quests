import 'package:epicquests/core/resources/app_images.dart';
import 'package:epicquests/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// Background image with blur overlay for avatar selection screen
class AvatarBackground extends StatelessWidget {
  const AvatarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(AppImages.avatarCoverPage, fit: BoxFit.cover),
        ),

        // Blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: AppColors.backgroundDark.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
