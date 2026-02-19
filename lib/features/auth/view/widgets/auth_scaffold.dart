import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/app_images.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable scaffold for auth screens with game-styled background
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background map image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.map),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withValues(alpha: 0.85),
                    AppColors.primaryShade90.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
