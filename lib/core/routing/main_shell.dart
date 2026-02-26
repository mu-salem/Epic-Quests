import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'widgets/pixel_nav_bar.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  final List<NavItem> _items = const [
    NavItem(icon: 'assets/icons/homeQuestIcon.svg', label: 'Quests'),
    NavItem(icon: 'assets/icons/heroProfileIcon.svg', label: 'Hero'),
    NavItem(icon: 'assets/icons/statsBarChartIcon.svg', label: 'Stats'),
    NavItem(icon: 'assets/icons/monthlyCalendarIcon.svg', label: 'Calendar'),
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
      bottomNavigationBar: PixelNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        items: _items,
        scaleAnimations: _scaleAnimations,
        onTap: _onTap,
      ),
    );
  }
}
