import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/services/xp_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/hero_profile.dart';
import '../../viewmodel/profile_viewmodel.dart';

class ProfileHeader extends StatelessWidget {
  final HeroProfile hero;
  final ProfileStats stats;

  const ProfileHeader({super.key, required this.hero, required this.stats});

  @override
  Widget build(BuildContext context) {
    final xpPercent = XPService.calculateProgress(
      currentXP: hero.currentXP,
      level: hero.level,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryShade70, AppColors.backgroundSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // ─── Avatar + Name ────────────────────────────
          Row(
            children: [
              // Crown badge + avatar
              Stack(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        hero.avatarAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text('🧙', style: TextStyle(fontSize: 36.sp)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 1.5,
                        ),
                      ),
                      child: Text('👑', style: TextStyle(fontSize: 10.sp)),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 10.sp,
                        color: AppColors.accent,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'LVL ${hero.level}',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 7.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${hero.currentXP}/${hero.maxXP} XP',
                          style: TextStyle(
                            fontFamily: 'VT323',
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // XP Progress Bar
                    Stack(
                      children: [
                        Container(
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark,
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: xpPercent,
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                              ),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ─── Stats Row ────────────────────────────────
          Row(
            children: [
              _StatChip(
                iconWidget: AppIcons.completedQuest(width: 20.w, height: 20.h),
                label: 'DONE',
                value: '${stats.completedQuests}',
              ),
              _StatChip(
                iconWidget: AppIcons.streakFire(width: 20.w, height: 20.h),
                label: 'STREAK',
                value: '${stats.currentStreak}d',
              ),
              _StatChip(
                iconWidget: AppIcons.questChecklist(width: 20.w, height: 20.h),
                label: 'ACTIVE',
                value: '${stats.activeQuests}',
              ),
              _StatChip(
                iconWidget: AppIcons.rewardMedal(width: 20.w, height: 20.h),
                label: 'RATE',
                value: '${stats.completionRate}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;

  const _StatChip({
    required this.iconWidget,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            iconWidget,
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 7.sp,
                color: AppColors.accent,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 10.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
