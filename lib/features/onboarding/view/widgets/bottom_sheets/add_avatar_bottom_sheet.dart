import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../avatar/avatar_template_grid.dart';
import 'avatar_name_section.dart';
import 'avatar_description_field.dart';

class AddAvatarBottomSheet extends StatefulWidget {
  const AddAvatarBottomSheet({
    super.key,
    required this.templates,
    required this.onCreateAvatar,
  });

  final List<AvatarTemplate> templates;
  final Function(AvatarTemplate template, String? customName, String? description) onCreateAvatar;

  @override
  State<AddAvatarBottomSheet> createState() => _AddAvatarBottomSheetState();
}

class _AddAvatarBottomSheetState extends State<AddAvatarBottomSheet> {
  int _selectedTemplateIndex = 0;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _useCustomName = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    final template = widget.templates[_selectedTemplateIndex];
    final customName = _useCustomName && _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : null;
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    widget.onCreateAvatar(template, customName, description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = widget.templates[_selectedTemplateIndex];
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'CREATE NEW AVATAR',
                  style: AppTextStyles.h3.copyWith(color: AppColors.accent),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: 20.h + bottomPadding + bottomSafeArea,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template Selection Label
                  Text(
                    'SELECT CHARACTER',
                    style: AppTextStyles.bodyS.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HeightSpacer(12),

                  // Template Grid
                  AvatarTemplateGrid(
                    templates: widget.templates,
                    selectedIndex: _selectedTemplateIndex,
                    onTemplateSelected: (index) {
                      setState(() {
                        _selectedTemplateIndex = index;
                      });
                    },
                  ),

                  HeightSpacer(24),

                  // Custom Name Section
                  AvatarNameSection(
                    useCustomName: _useCustomName,
                    onUseCustomNameChanged: (value) {
                      setState(() {
                        _useCustomName = value;
                      });
                    },
                    nameController: _nameController,
                    defaultName: selectedTemplate.name,
                  ),

                  HeightSpacer(20),

                  // Description Field
                  AvatarDescriptionField(
                    controller: _descriptionController,
                  ),

                  HeightSpacer(24),

                  // Create Button
                  PrimaryButton(
                    text: 'CREATE AVATAR',
                    width: double.infinity,
                    onPressed: _handleCreate,
                    backgroundColor: AppColors.panelLight,
                    borderColor: AppColors.accent,
                    shadowColor: AppColors.accent,
                    textColor: AppColors.backgroundDark,
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
