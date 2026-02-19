import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:epicquests/core/widgets/widgets.dart';
import 'package:epicquests/features/onboarding/model/avatar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../avatar/avatar_preview_card.dart';
import 'avatar_name_section.dart';
import 'avatar_description_field.dart';
import '../common/delete_avatar_button.dart';

class EditAvatarBottomSheet extends StatefulWidget {
  const EditAvatarBottomSheet({
    super.key,
    required this.avatar,
    required this.onUpdate,
    required this.onDelete,
  });

  final AvatarItem avatar;
  final Function(String? customName, String? description) onUpdate;
  final VoidCallback onDelete;

  @override
  State<EditAvatarBottomSheet> createState() => _EditAvatarBottomSheetState();
}

class _EditAvatarBottomSheetState extends State<EditAvatarBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _useCustomName = false;

  @override
  void initState() {
    super.initState();
    
    // Check if avatar has custom name (different from template name)
    _useCustomName = widget.avatar.displayName != widget.avatar.templateName;
    
    _nameController = TextEditingController(
      text: _useCustomName ? widget.avatar.displayName : '',
    );
    _descriptionController = TextEditingController(
      text: widget.avatar.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    final customName = _useCustomName && _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : null;
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    widget.onUpdate(customName, description);
    Navigator.of(context).pop();
  }

  void _handleDelete() {
    widget.onDelete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.75,
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
                  'EDIT AVATAR',
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
                  // Avatar Preview with Stats
                  AvatarPreviewCard(avatar: widget.avatar),

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
                    defaultName: widget.avatar.templateName,
                  ),

                  HeightSpacer(20),

                  // Description Field
                  AvatarDescriptionField(
                    controller: _descriptionController,
                  ),

                  HeightSpacer(24),

                  // Update Button
                  PrimaryButton(
                    text: 'UPDATE AVATAR',
                    width: double.infinity,
                    onPressed: _handleUpdate,
                    backgroundColor: AppColors.panelLight,
                    borderColor: AppColors.accent,
                    shadowColor: AppColors.accent,
                    textColor: AppColors.backgroundDark,
                  ),

                  HeightSpacer(12),

                  // Delete Button
                  DeleteAvatarButton(onPressed: _handleDelete),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
