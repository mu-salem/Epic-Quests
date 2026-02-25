import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../resources/app_icons.dart';
import '../theme/app_colors.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  final List<_NavItem> _items = const [
    _NavItem(icon: 'assets/icons/homeQuestIcon.svg', label: 'Quests'),
    _NavItem(icon: 'assets/icons/heroProfileIcon.svg', label: 'Hero'),
    _NavItem(icon: 'assets/icons/statsBarChartIcon.svg', label: 'Stats'),
    _NavItem(icon: 'assets/icons/monthlyCalendarIcon.svg', label: 'Calendar'),
  ];

  @override
  void initState() {
    super.initState();
    _scaleControllers = List.generate(
      _items.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _scaleAnimations = _scaleControllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 1.25,
          ).animate(CurvedAnimation(parent: c, curve: Curves.elasticOut)),
        )
        .toList();

    // Animate current tab on start
    _scaleControllers[widget.navigationShell.currentIndex].forward();
  }

  @override
  void dispose() {
    for (final c in _scaleControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (index == widget.navigationShell.currentIndex) return;

    // Animate selected tab
    for (int i = 0; i < _scaleControllers.length; i++) {
      if (i == index) {
        _scaleControllers[i].forward();
      } else {
        _scaleControllers[i].reverse();
      }
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: widget.navigationShell,
      extendBody:
          true, // Allows content to be behind the navbar if we add transparency
      bottomNavigationBar: _PixelNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        items: _items,
        scaleAnimations: _scaleAnimations,
        onTap: _onTap,
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _PixelNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final List<Animation<double>> scaleAnimations;
  final ValueChanged<int> onTap;

  const _PixelNavBar({
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
