import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../auth/data/remote/api_auth_repository.dart';
import '../../../auth/view/widgets/auth_text_field.dart';
import '../../viewmodel/account_viewmodel.dart';
import '../widgets/change_password_bottom_sheet.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late AccountViewModel _viewModel;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = AccountViewModel();
    // Load profile on init, then populate the name controller
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.loadProfile();
      if (_viewModel.user != null && mounted) {
        _nameController.text = _viewModel.user!.name ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    final success = await _viewModel.updateProfile(newName);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else if (_viewModel.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.error!)));
    }
  }

  void _showChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: _viewModel,
        child: const ChangePasswordBottomSheet(),
      ),
    );
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.error, width: 2),
        ),
        title: Text(
          '⚠️ LOGOUT?',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 8.sp,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
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
              'LOGOUT',
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

    if (confirmed == true && mounted) {
      await ApiAuthRepository().logout();
      if (mounted) {
        context.go('/'); // go to splash which routes to login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          title: Text(
            '[ ACCOUNT & SECURITY ]',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 10.sp,
              color: AppColors.accent,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: Consumer<AccountViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading && vm.user == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (vm.error != null && vm.user == null) {
              return Center(
                child: Text(
                  vm.error!,
                  style: TextStyle(
                    color: AppColors.error,
                    fontFamily: 'VT323',
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            final user = vm.user;
            if (user == null) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERSONAL INFO',
                    style: AppTextStyles.bodyS.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HeightSpacer(16),

                  // Readonly Email Field
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSoft,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: AppColors.textMuted,
                        ),
                        WidthSpacer(12),
                        Expanded(
                          child: Text(
                            user.email,
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.lock_outline,
                          color: AppColors.textMuted,
                          size: 16,
                        ),
                      ],
                    ),
                  ),

                  HeightSpacer(16),

                  // Editable Name Field
                  AuthTextField(
                    controller: _nameController,
                    label: 'Display Name',
                  ),

                  HeightSpacer(24),

                  PrimaryButton(
                    text: 'SAVE CHANGES',
                    width: double.infinity,
                    onPressed: vm.isLoading ? null : _saveProfile,
                    isLoading: vm.isLoading,
                  ),

                  HeightSpacer(48),

                  Text(
                    'SECURITY',
                    style: AppTextStyles.bodyS.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HeightSpacer(16),

                  PrimaryButton(
                    text: 'CHANGE PASSWORD',
                    width: double.infinity,
                    onPressed: _showChangePasswordSheet,
                    backgroundColor: AppColors.panelDark,
                    borderColor: AppColors.border,
                    textColor: AppColors.textPrimary,
                    shadowColor: Colors.transparent,
                  ),

                  HeightSpacer(48),

                  // Logout Button
                  TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      'LOGOUT',
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.error,
                        fontFamily: 'PressStart2P',
                        fontSize: 10.sp,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      minimumSize: const Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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
