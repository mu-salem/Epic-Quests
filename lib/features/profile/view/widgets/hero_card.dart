import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/hero_profile.dart';

class HeroCard extends StatelessWidget {
  final HeroProfile hero;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HeroCard({
    super.key,
    required this.hero,
    this.isActive = false,
    required this.onSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.backgroundSoft,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
            width: isActive ? 2.5 : 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Active indicator
            if (isActive)
              Positioned(
                top: 6.h,
                right: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 5.sp,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? AppColors.accent : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        hero.avatarAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text('🧙', style: TextStyle(fontSize: 28.sp)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Name
                  Text(
                    hero.name,
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 7.sp,
                      color: isActive
                          ? AppColors.accent
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // Level + XP
                  Text(
                    'Lv.${hero.level} | ${hero.currentXP}XP',
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 12.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionBtn(
                        icon: Icons.edit,
                        color: AppColors.primary,
                        onTap: onEdit,
                      ),
                      SizedBox(width: 8.w),
                      _ActionBtn(
                        icon: Icons.delete_outline,
                        color: AppColors.error,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: color, size: 16.r),
      ),
    );
  }
}
