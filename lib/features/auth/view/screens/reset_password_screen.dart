import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/error_message_box.dart';
import '../../viewmodel/reset_password_viewmodel.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/pixel_header_card.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordViewModel _viewModel;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ResetPasswordViewModel(email: widget.email, code: widget.code);

    _passwordController.addListener(() {
      _viewModel.updatePassword(_passwordController.text);
    });

    _confirmPasswordController.addListener(() {
      _viewModel.updateConfirmPassword(_confirmPasswordController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final success = await _viewModel.resetPassword();

    if (success && mounted) {
      // Navigate to login
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: AuthScaffold(
        body: Consumer<ResetPasswordViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                HeightSpacer(40),

                // Header
                const PixelHeaderCard(
                  title: 'RESET PASSWORD',
                  subtitle: 'Choose a new password for your quest',
                ),

                HeightSpacer(40),

                // Password field
                AuthTextField(
                  controller: _passwordController,
                  label: 'NEW PASSWORD',
                  hint: '••••••••',
                  obscureText: true,
                  errorText: viewModel.passwordError,
                  enabled: !viewModel.isLoading,
                ),

                HeightSpacer(20),

                // Confirm password field
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRM NEW PASSWORD',
                  hint: '••••••••',
                  obscureText: true,
                  errorText: viewModel.confirmPasswordError,
                  enabled: !viewModel.isLoading,
                ),

                HeightSpacer(32),

                // Error message
                if (viewModel.errorMessage != null) ...[  
                  ErrorMessageBox(message: viewModel.errorMessage!),
                  HeightSpacer(16),
                ],

                // Reset button
                PrimaryButton(
                  onPressed: viewModel.isLoading ? null : _handleResetPassword,
                  text: 'RESET PASSWORD',
                  isLoading: viewModel.isLoading,
                  backgroundColor: AppColors.panelLight,
                  borderColor: AppColors.accent,
                  shadowColor: AppColors.accent,
                  textColor: AppColors.backgroundDark,
                  width: double.infinity,
                ),

                HeightSpacer(20),
              ],
            );
          },
        ),
      ),
    );
  }
}
