import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/quest.dart';
import '../../viewmodel/add_quest_viewmodel.dart';
import 'form_fields/form_fields.dart';

class AddQuestBottomSheet extends StatefulWidget {
  const AddQuestBottomSheet({
    super.key,
    this.questToEdit,
  });

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
    _viewModel = AddQuestViewModel(questToEdit: widget.questToEdit);
    
    // Initialize controllers from ViewModel
    _titleController.text = _viewModel.title;
    _descriptionController.text = _viewModel.description ?? '';
    
    // Listen to controller changes and update ViewModel
    _titleController.addListener(() {
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
    final quest = _viewModel.saveQuest();
    if (quest != null) {
      Navigator.of(context).pop(quest);
    }
  }

  Future<void> _deleteQuest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.panelDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: AppColors.border, width: 2),
        ),
        title: Text(
          'Delete Quest?',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this quest? This action cannot be undone.',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCEL',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textMuted,
                fontSize: 13.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'DELETE',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.error,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 
                  MediaQuery.of(context).padding.bottom + 20.h,
        ),
        child: Consumer<AddQuestViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        viewModel.isEditing ? 'EDIT QUEST' : '+ NEW QUEST',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Title Field
                  QuestTitleField(
                    controller: _titleController,
                    errorText: viewModel.titleError,
                  ),

                  SizedBox(height: 16.h),

                  // Description Field
                  QuestDescriptionField(
                    controller: _descriptionController,
                  ),

                  SizedBox(height: 16.h),

                  // Priority Selector
                  QuestPrioritySelector(
                    selectedPriority: viewModel.priority,
                    onPriorityChanged: viewModel.updatePriority,
                  ),

                  SizedBox(height: 16.h),

                  // Deadline Picker
                  QuestDeadlinePicker(
                    deadline: viewModel.deadline,
                    onTap: _selectDeadline,
                  ),

                  SizedBox(height: 24.h),

                  // Action Buttons
                  QuestFormActions(
                    isEditing: viewModel.isEditing,
                    onSave: _saveQuest,
                    onDelete: _deleteQuest,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
