import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../viewmodel/account_viewmodel.dart';
import 'change_password_header.dart';
import 'password_text_field.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    final vm = context.read<AccountViewModel>();
    final success = await vm.updatePassword(
      oldPassword: oldPass,
      newPassword: newPass,
      confirmPassword: confirmPass,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
    } else if (mounted && vm.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
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
              const ChangePasswordHeader(),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 20.h,
                    bottom: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PasswordTextField(
                        controller: _oldPasswordController,
                        label: 'Old Password',
                      ),
                      HeightSpacer(16),
                      PasswordTextField(
                        controller: _newPasswordController,
                        label: 'New Password',
                      ),
                      HeightSpacer(16),
                      PasswordTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm New Password',
                      ),
                      HeightSpacer(24),
                    ],
                  ),
                ),
              ),

              // Fixed Action Area
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 10.h,
                  bottom: 20.h + bottomPadding + bottomSafeArea,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundDark,
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 2),
                  ),
                ),
                child: Consumer<AccountViewModel>(
                  builder: (context, vm, _) {
                    return PrimaryButton(
                      text: 'UPDATE SECRETS',
                      width: double.infinity,
                      onPressed: vm.isLoading ? null : _submit,
                      isLoading: vm.isLoading,
                      backgroundColor: AppColors.panelLight,
                      borderColor: AppColors.accent,
                      shadowColor: AppColors.accent,
                      textColor: AppColors.backgroundDark,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
