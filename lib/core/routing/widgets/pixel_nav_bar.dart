import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/app_icons.dart';
import '../../theme/app_colors.dart';

class NavItem {
  final String icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

class PixelNavBar extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final List<Animation<double>> scaleAnimations;
  final ValueChanged<int> onTap;

  const PixelNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.scaleAnimations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.panelDark.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Row(
          children: List.generate(items.length, (i) {
            final isSelected = i == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedBuilder(
                  animation: scaleAnimations[i],
                  builder: (context, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: scaleAnimations[i].value,
                        child: _getNavIcon(
                          items[i].icon,
                          width: 28.w,
                          height: 28.h,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        items[i].label.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 6.sp,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(height: 4.h),
                        Container(
                          width: 4.w,
                          height: 4.h,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _getNavIcon(String path, {double? width, double? height}) {
    if (path.contains('homeQuestIcon')) {
      return AppIcons.homeQuest(width: width, height: height);
    }
    if (path.contains('heroProfileIcon')) {
      return AppIcons.heroProfile(width: width, height: height);
    }
    if (path.contains('statsBarChartIcon')) {
      return AppIcons.statsBarChart(width: width, height: height);
    }
    if (path.contains('monthlyCalendarIcon')) {
      return AppIcons.monthlyCalendar(width: width, height: height);
    }
    return SizedBox(width: width, height: height);
  }
}
