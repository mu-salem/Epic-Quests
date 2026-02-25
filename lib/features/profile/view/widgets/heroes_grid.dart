import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/model/hero_profile.dart';
import 'hero_card.dart';

class HeroesGrid extends StatelessWidget {
  final List<HeroProfile> heroes;
  final String? activeHeroId;
  final ValueChanged<HeroProfile> onSelect;
  final ValueChanged<HeroProfile> onDelete;
  final ValueChanged<HeroProfile> onEdit;

  const HeroesGrid({
    super.key,
    required this.heroes,
    this.activeHeroId,
    required this.onSelect,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (heroes.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            'No heroes yet. Create one!',
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 16.sp,
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: heroes.length,
        itemBuilder: (context, index) {
          final hero = heroes[index];
          return HeroCard(
            hero: hero,
            isActive: hero.id == activeHeroId,
            onSelect: () => onSelect(hero),
            onDelete: () => onDelete(hero),
            onEdit: () => onEdit(hero),
          );
        },
      ),
    );
  }
}
