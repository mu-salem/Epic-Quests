import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../tasks/viewmodel/tasks_viewmodel.dart';
import '../../viewmodel/profile_viewmodel.dart';
import '../widgets/empty_hero_state.dart';
import '../widgets/heroes_grid.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      tasksViewModel: context.read<TasksViewModel>(),
    );
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Consumer<ProfileViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            final activeHero = vm.activeHero;

            return CustomScrollView(
              slivers: [
                // ─── App Bar ─────────────────────────────
                SliverAppBar(
                  backgroundColor: AppColors.backgroundDark,
                  expandedHeight: 0,
                  floating: true,
                  title: Text(
                    '[ HERO PROFILE ]',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 10.sp,
                      color: AppColors.accent,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.accent,
                      ),
                      onPressed: () => context.go(AppRouter.onboardingAvatar),
                      tooltip: 'New Hero',
                    ),
                  ],
                ),

                // ─── Profile Header ───────────────────────
                SliverToBoxAdapter(
                  child: activeHero != null
                      ? ProfileHeader(
                          hero: activeHero,
                          stats: vm.getStatsForHero(activeHero),
                        )
                      : const EmptyHeroState(),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                // ─── Heroes Section ───────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      '[ MY HEROES ]',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 8.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 4.h)),
                SliverToBoxAdapter(
                  child: HeroesGrid(
                    heroes: vm.heroes,
                    activeHeroId: vm.activeHero?.id,
                    onSelect: (hero) => vm.selectHero(hero),
                    onDelete: (hero) =>
                        _confirmDeleteHero(context, vm, hero.id),
                    onEdit: (hero) => context.go(AppRouter.onboardingAvatar),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                // ─── Settings Row ─────────────────────────
                SliverToBoxAdapter(
                  child: ProfileSettingsRow(
                    isSoundEnabled: vm.isSoundEnabled,
                    onToggleSound: vm.toggleSound,
                    onStatsPressed: () => context.push(AppRouter.stats),
                    onAccountPressed: () => context.push(AppRouter.account),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 80.h)),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteHero(
    BuildContext context,
    ProfileViewModel vm,
    String heroId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.error, width: 2),
        ),
        title: Text(
          '⚠️ DELETE HERO?',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 8.sp,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'This hero and all their quests will be lost forever!',
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 7.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'DELETE',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 7.sp,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await vm.deleteHero(heroId);
    }
  }
}
