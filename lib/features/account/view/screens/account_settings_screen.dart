import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../auth/data/remote/api_auth_repository.dart';
import '../../../auth/view/widgets/auth_text_field.dart';
import '../../viewmodel/account_viewmodel.dart';
import '../dialogs/logout_dialog.dart';
import '../widgets/account_section_title.dart';
import '../widgets/change_password_bottom_sheet.dart';
import '../widgets/logout_button.dart';
import '../widgets/readonly_email_field.dart';

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
    final confirmed = await showLogoutDialog(context);

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
                  const AccountSectionTitle(title: 'PERSONAL INFO'),
                  HeightSpacer(16),

                  // Readonly Email Field
                  ReadonlyEmailField(email: user.email),
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

                  const AccountSectionTitle(title: 'SECURITY'),
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
                  LogoutButton(onLogout: _logout),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
