import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../model/quest.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  QuestPriority _selectedPriority = QuestPriority.medium;
  DateTime? _selectedDeadline;

  bool get _isEditing => widget.questToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.questToEdit!.title;
      _descriptionController.text = widget.questToEdit!.description ?? '';
      _selectedPriority = widget.questToEdit!.priority;
      _selectedDeadline = widget.questToEdit!.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? now,
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
      setState(() => _selectedDeadline = picked);
    }
  }

  void _saveQuest() {
    if (!_formKey.currentState!.validate()) return;

    final quest = _isEditing
        ? widget.questToEdit!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            deadline: _selectedDeadline,
            priority: _selectedPriority,
          )
        : Quest(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            deadline: _selectedDeadline,
            priority: _selectedPriority,
          );

    Navigator.of(context).pop(quest);
  }

  void _deleteQuest() async {
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

    if (confirmed == true) {
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    _isEditing ? 'EDIT QUEST' : '+ NEW QUEST',
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
              Text(
                'Quest Title *',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _titleController,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter quest name...',
                  hintStyle: AppTextStyles.hint,
                  filled: true,
                  fillColor: AppColors.panelDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.border, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.border, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.error, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quest title is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),

              // Description Field
              Text(
                'Description (Optional)',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _descriptionController,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Quest details...',
                  hintStyle: AppTextStyles.hint,
                  filled: true,
                  fillColor: AppColors.panelDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.border, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.border, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Priority Selector
              Text(
                'Priority',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: QuestPriority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPriority = priority),
                      child: Container(
                        margin: EdgeInsets.only(right: priority != QuestPriority.high ? 8.w : 0),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.panelDark,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryTint70 : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              priority.icon,
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              priority.label,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 13.sp,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 16.h),

              // Deadline Picker
              Text(
                'Deadline (Optional)',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _selectDeadline,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.panelDark,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18.sp,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        _selectedDeadline != null
                            ? '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}'
                            : 'Select deadline',
                        style: AppTextStyles.bodyM.copyWith(
                          color: _selectedDeadline != null
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Delete Button (only in edit mode)
              if (_isEditing) ...[
                PrimaryButton(
                  text: 'DELETE QUEST',
                  width: double.infinity,
                  onPressed: _deleteQuest,
                  backgroundColor: AppColors.error,
                  borderColor: AppColors.error,
                  shadowColor: AppColors.error.withOpacity(0.3),
                ),
                SizedBox(height: 12.h),
              ],

              // Save Button
              PrimaryButton(
                text: _isEditing ? 'UPDATE QUEST' : 'CREATE QUEST',
                width: double.infinity,
                onPressed: _saveQuest,
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
