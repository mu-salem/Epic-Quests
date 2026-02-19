import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/pixel_notification.dart';
import '../../viewmodel/register_viewmodel.dart';
import '../widgets/auth_link_row.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/pixel_header_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterViewModel _viewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();

    _emailController.addListener(() {
      _viewModel.updateEmail(_emailController.text);
    });

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final success = await _viewModel.register();

    if (success && mounted) {
      // Show success notification
      PixelNotification.show(
        context,
        message: _viewModel.successMessage ?? 'Success!',
        type: NotificationType.success,
      );

      // Navigate to avatar selection
      context.go(AppRouter.onboardingAvatar);
    } else if (mounted && _viewModel.errorMessage != null) {
      // Show error notification
      PixelNotification.show(
        context,
        message: _viewModel.errorMessage!,
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: AuthScaffold(
        body: Consumer<RegisterViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                HeightSpacer(40),

                // Header
                const PixelHeaderCard(
                  title: 'REGISTER',
                  subtitle: 'Create your hero account',
                ),

                HeightSpacer(40),

                // Email field
                AuthTextField(
                  controller: _emailController,
                  label: 'EMAIL',
                  hint: 'hero@epicquests.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: viewModel.emailError,
                  enabled: !viewModel.isLoading,
                ),

                HeightSpacer(20),

                // Password field
                AuthTextField(
                  controller: _passwordController,
                  label: 'PASSWORD',
                  hint: '••••••••',
                  obscureText: true,
                  errorText: viewModel.passwordError,
                  enabled: !viewModel.isLoading,
                ),

                HeightSpacer(20),

                // Confirm password field
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRM PASSWORD',
                  hint: '••••••••',
                  obscureText: true,
                  errorText: viewModel.confirmPasswordError,
                  enabled: !viewModel.isLoading,
                ),

                HeightSpacer(32),

                // Register button
                PrimaryButton(
                  onPressed: viewModel.isLoading ? null : _handleRegister,
                  text: 'CREATE HERO',
                  isLoading: viewModel.isLoading,
                  backgroundColor: AppColors.panelLight,
                  borderColor: AppColors.accent,
                  shadowColor: AppColors.accent,
                  textColor: AppColors.backgroundDark,
                  width: double.infinity,
                ),

                HeightSpacer(24),

                // Login link
                AuthLinkRow(
                  text: 'Already have an account?',
                  actionText: 'Login',
                  onTap: viewModel.isLoading
                      ? () {}
                      : () => context.go(AppRouter.login),
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
