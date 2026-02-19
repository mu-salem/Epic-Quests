import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../model/quest.dart';
import '../../viewmodel/tasks_viewmodel.dart';
import '../utils/quest_modal_helper.dart';
import '../widgets/home_content_widget.dart';
import '../widgets/new_quest_button.dart';


class TasksHomeScreen extends StatefulWidget {
  final String? heroName;
  
  const TasksHomeScreen({super.key, this.heroName});

  @override
  State<TasksHomeScreen> createState() => _TasksHomeScreenState();
}

class _TasksHomeScreenState extends State<TasksHomeScreen> with SingleTickerProviderStateMixin {
  // Tabs
  late TabController _tabController;

  // Search Controller
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize ViewModel with hero name
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<TasksViewModel>();
      final heroName = widget.heroName ?? await _getLastSelectedHero();
      
      if (heroName != null) {
        await viewModel.init(heroName);
      } else {
        // No hero selected, redirect back to splash
        if (mounted) {
          context.go('/');
        }
      }
    });
  }
  
  /// Get last selected hero from repository
  Future<String?> _getLastSelectedHero() async {
    final viewModel = context.read<TasksViewModel>();
    return await viewModel.getLastSelectedHero();
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
    
    // Switch to appropriate tab based on new status
    if (viewModel.wasQuestJustCompleted(questId)) {
      _tabController.animateTo(1); 
    } else {
      _tabController.animateTo(0); 
    }
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
          Positioned.fill(
            child: Container(
              color: AppColors.backgroundDark,
            ),
          ),

          // Dark overlay for readability
          Positioned.fill(
            child: Container(
              color: AppColors.black.withValues(alpha: 0.4),
            ),
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

          // Bottom "New Quest" Button
          NewQuestButton(
            onPressed: _handleNewQuestPress,
          ),
        ],
      ),
    );
  }
}
