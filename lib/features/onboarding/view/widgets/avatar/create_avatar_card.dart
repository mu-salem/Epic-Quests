import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAvatarCard extends StatelessWidget {
  const CreateAvatarCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Styling matches AvatarCard when it's NOT selected
    const scale = 0.90;
    const opacity = 0.55;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border, width: 1.2),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.primaryShade90,
                    AppColors.backgroundSoft,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryTint70,
                        width: 2,
                      ),
                      color: AppColors.primaryShade90,
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.primaryTint70,
                      size: 36.sp,
                    ),
                  ),
                  HeightSpacer(24),
                  Text(
                    'CREATE AVATAR',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.primaryTint70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
