import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../tasks/model/recurring_quest.dart';
import '../../../viewmodel/recurring_viewmodel.dart';

class AddRecurringQuestBottomSheet extends StatefulWidget {
  final String heroId;

  const AddRecurringQuestBottomSheet({super.key, required this.heroId});

  @override
  State<AddRecurringQuestBottomSheet> createState() =>
      _AddRecurringQuestBottomSheetState();
}

class _AddRecurringQuestBottomSheetState
    extends State<AddRecurringQuestBottomSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  RecurrenceType _type = RecurrenceType.daily;
  String _priority = 'medium';
  int _customDays = 3;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _createQuest() {
    if (_titleCtrl.text.trim().isEmpty) return;

    final rq = RecurringQuest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.isNotEmpty ? _descCtrl.text.trim() : null,
      priority: _priority,
      recurrenceType: _type,
      customIntervalDays: _customDays,
      nextDueAt: DateTime.now(),
      heroId: widget.heroId,
    );

    context.read<RecurringViewModel>().saveQuest(rq).then((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSoft,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            border: Border.all(color: AppColors.border),
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '[ NEW RECURRING QUEST ]',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 7.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InputField(controller: _titleCtrl, label: 'Quest Title'),
                      SizedBox(height: 8.h),
                      _InputField(
                        controller: _descCtrl,
                        label: 'Description (optional)',
                      ),
                      SizedBox(height: 12.h),

                      // Priority Selection
                      Text(
                        'Priority',
                        style: TextStyle(
                          fontFamily: 'VT323',
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PriorityButton(
                            label: 'LOW',
                            color: AppColors.success,
                            isSelected: _priority == 'low',
                            onTap: () => setState(() => _priority = 'low'),
                          ),
                          _PriorityButton(
                            label: 'MEDIUM',
                            color: AppColors.warning,
                            isSelected: _priority == 'medium',
                            onTap: () => setState(() => _priority = 'medium'),
                          ),
                          _PriorityButton(
                            label: 'HIGH',
                            color: AppColors.error,
                            isSelected: _priority == 'high',
                            onTap: () => setState(() => _priority = 'high'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Recurrence type
                      Text(
                        'Recurrence',
                        style: TextStyle(
                          fontFamily: 'VT323',
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: RecurrenceType.values.map((t) {
                          return ChoiceChip(
                            label: Text(
                              '${t.icon} ${t.label}',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 5.sp,
                                color: _type == t
                                    ? AppColors.backgroundDark
                                    : AppColors.textMuted,
                              ),
                            ),
                            selected: _type == t,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.backgroundDark,
                            onSelected: (_) => setState(() => _type = t),
                          );
                        }).toList(),
                      ),

                      if (_type == RecurrenceType.custom) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              'Every',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 16.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: AppColors.primary,
                              ),
                              onPressed: _customDays > 1
                                  ? () => setState(() => _customDays--)
                                  : null,
                            ),
                            Text(
                              '$_customDays',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 10.sp,
                                color: AppColors.accent,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.primary,
                              ),
                              onPressed: () => setState(() => _customDays++),
                            ),
                            Text(
                              'days',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 16.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _createQuest,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Center(
                    child: Text(
                      'CREATE',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 8.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriorityButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(color: isSelected ? color : AppColors.border),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 5.sp,
            color: isSelected ? color : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _InputField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontFamily: 'VT323',
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'VT323',
          fontSize: 14.sp,
          color: AppColors.textMuted,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(6.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
    );
  }
}
