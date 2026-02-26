import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/quest.dart';
import '../../viewmodel/add_quest_viewmodel.dart';
import '../dialogs/delete_quest_dialog.dart';
import 'form_fields/form_fields.dart';

class AddQuestBottomSheet extends StatefulWidget {
  const AddQuestBottomSheet({super.key, this.questToEdit});

  final Quest? questToEdit;

  @override
  State<AddQuestBottomSheet> createState() => _AddQuestBottomSheetState();
}

class _AddQuestBottomSheetState extends State<AddQuestBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late AddQuestViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 [AddQuestSheet] initState called');
    _viewModel = AddQuestViewModel(questToEdit: widget.questToEdit);

    // Initialize controllers from ViewModel
    _titleController.text = _viewModel.title;
    _descriptionController.text = _viewModel.description ?? '';
    debugPrint('🚀 [AddQuestSheet] Initial title: "${_titleController.text}"');

    // Listen to controller changes and update ViewModel
    _titleController.addListener(() {
      debugPrint(
        '👂 [AddQuestSheet] Title controller changed: "${_titleController.text}"',
      );
      _viewModel.updateTitle(_titleController.text);
    });

    _descriptionController.addListener(() {
      _viewModel.updateDescription(_descriptionController.text);
    });

    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.deadline ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.panelDark,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _viewModel.updateDeadline(picked);
    }
  }

  void _saveQuest() {
    debugPrint('💾 [AddQuestSheet] _saveQuest called');
    debugPrint(
      '💾 [AddQuestSheet] Controller text: "${_titleController.text}"',
    );
    final quest = _viewModel.saveQuest();
    if (quest != null) {
      debugPrint('✅ [AddQuestSheet] Quest saved, popping with result');
      Navigator.of(context).pop(quest);
    } else {
      debugPrint('❌ [AddQuestSheet] Quest validation failed, not closing');
    }
  }

  Future<void> _deleteQuest() async {
    final confirmed = await showDeleteQuestDialog(context);

    if (confirmed == true && mounted) {
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  20.h,
            ),
            child: Consumer<AddQuestViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Fixed)
                    Row(
                      children: [
                        AppIcons.questScroll(width: 28.w, height: 28.h),
                        WidthSpacer(10),
                        Text(
                          viewModel.isEditing ? 'EDIT QUEST' : '+ NEW QUEST',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    HeightSpacer(20),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Field
                            QuestTitleField(
                              controller: _titleController,
                              errorText: viewModel.titleError,
                            ),
                            HeightSpacer(16),

                            // Description Field
                            QuestDescriptionField(
                              controller: _descriptionController,
                            ),
                            HeightSpacer(16),

                            // Priority Selector
                            QuestPrioritySelector(
                              selectedPriority: viewModel.priority,
                              onPriorityChanged: viewModel.updatePriority,
                            ),
                            HeightSpacer(16),

                            // Deadline Picker
                            QuestDeadlinePicker(
                              deadline: viewModel.deadline,
                              onTap: _selectDeadline,
                            ),
                            HeightSpacer(16),
                          ],
                        ),
                      ),
                    ),

                    HeightSpacer(8),

                    // Action Buttons (Fixed at bottom)
                    QuestFormActions(
                      isEditing: viewModel.isEditing,
                      onSave: _saveQuest,
                      onDelete: _deleteQuest,
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
