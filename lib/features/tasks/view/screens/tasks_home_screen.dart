import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../model/quest.dart';
import '../../viewmodel/tasks_viewmodel.dart';
import '../utils/quest_modal_helper.dart';
import '../widgets/home_content_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';

class TasksHomeScreen extends StatefulWidget {
  final String? heroName;

  const TasksHomeScreen({super.key, this.heroName});

  @override
  State<TasksHomeScreen> createState() => _TasksHomeScreenState();
}

class _TasksHomeScreenState extends State<TasksHomeScreen>
    with SingleTickerProviderStateMixin {
  // Tabs
  late TabController _tabController;

  // Search Controller
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 [TasksHomeScreen] initState called');
    debugPrint('🚀 [TasksHomeScreen] widget.heroName: ${widget.heroName}');
    _tabController = TabController(length: 2, vsync: this);

    // Initialize ViewModel with hero name
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('🚀 [TasksHomeScreen] postFrameCallback executing...');
      final viewModel = context.read<TasksViewModel>();
      final heroName = widget.heroName ?? await _getLastSelectedHero();
      debugPrint('🚀 [TasksHomeScreen] Resolved heroName: $heroName');

      if (heroName != null) {
        debugPrint(
          '✅ [TasksHomeScreen] Initializing viewModel with hero: $heroName',
        );
        await viewModel.init(heroName);
        debugPrint('✅ [TasksHomeScreen] ViewModel initialized');
      } else {
        debugPrint('❌ [TasksHomeScreen] No hero found, redirecting to splash');
        // No hero selected, redirect back to splash
        if (mounted) {
          context.go('/');
        }
      }
    });
  }

  /// Get last selected hero from repository
  Future<String?> _getLastSelectedHero() async {
    debugPrint('🔍 [TasksHomeScreen] Getting last selected hero...');
    final viewModel = context.read<TasksViewModel>();
    final heroId = await viewModel.getLastSelectedHero();
    debugPrint('🔍 [TasksHomeScreen] Last selected hero ID: $heroId');
    return heroId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Handle quest completion toggle
  void _handleQuestToggle(String questId) {
    final viewModel = context.read<TasksViewModel>();
    viewModel.toggleQuestCompletion(questId);
  }

  /// Handle quest tap (show edit modal)
  void _handleQuestTap(Quest quest) {
    QuestModalHelper.showEditQuestModal(
      context: context,
      viewModel: context.read<TasksViewModel>(),
      quest: quest,
    );
  }

  /// Handle new quest button press
  void _handleNewQuestPress() {
    QuestModalHelper.showAddQuestModal(
      context: context,
      viewModel: context.read<TasksViewModel>(),
    );
  }

  /// Handle avatar tap - navigate back to avatar selection
  void _handleAvatarTap() {
    context.go('/onboarding/avatar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background with overlay
          Positioned.fill(child: Container(color: AppColors.backgroundDark)),

          // Dark overlay for readability
          Positioned.fill(
            child: Container(color: AppColors.black.withValues(alpha: 0.4)),
          ),

          // Main Content
          SafeArea(
            child: HomeContentWidget(
              tabController: _tabController,
              searchController: _searchController,
              onSearchChanged: (value) {
                context.read<TasksViewModel>().updateSearchQuery(value);
              },
              onQuestToggle: _handleQuestToggle,
              onQuestTap: _handleQuestTap,
              onAvatarTap: _handleAvatarTap,
            ),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16.w,
                12.h,
                16.w,
                MediaQuery.of(context).padding.bottom + 16.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withValues(alpha: 0.15),
                    AppColors.backgroundDark.withValues(alpha: 0.9),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Pomodoro Button
                  GestureDetector(
                    onTap: () => context.push('/pomodoro'),
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSoft,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Center(
                        child: AppIcons.pomodoroSession(
                          width: 4.w,
                          height: 36.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // New Quest Button
                  Expanded(
                    child: PrimaryButton(
                      text: '+ NEW QUEST',
                      onPressed: _handleNewQuestPress,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
