import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/error_message_box.dart';
import '../../viewmodel/login_viewmodel.dart';
import '../widgets/auth_link_row.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/pixel_header_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel _viewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();

    _emailController.addListener(() {
      _viewModel.updateEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      _viewModel.updatePassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final success = await _viewModel.login();

    if (success && mounted) {
      // Navigate to home
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: AuthScaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                HeightSpacer(40),

                // Header
                const PixelHeaderCard(
                  title: 'LOGIN',
                  subtitle: 'Return to your quest',
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

                HeightSpacer(12),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: viewModel.isLoading
                        ? null
                        : () => context.push(AppRouter.forgotPasswordEmail),
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.bodyS.copyWith(
                        color: AppColors.accent,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.accent,
                      ),
                    ),
                  ),
                ),

                HeightSpacer(32),

                // Error message
                if (viewModel.errorMessage != null) ...[  
                  ErrorMessageBox(message: viewModel.errorMessage!),
                  HeightSpacer(16),
                ],

                // Login button
                PrimaryButton(
                  onPressed: viewModel.isLoading ? null : _handleLogin,
                  text: 'LOGIN',
                  isLoading: viewModel.isLoading,
                  backgroundColor: AppColors.panelLight,
                  borderColor: AppColors.accent,
                  shadowColor: AppColors.accent,
                  textColor: AppColors.backgroundDark,
                  width: double.infinity,
                ),

                HeightSpacer(24),

                // Register link
                AuthLinkRow(
                  text: 'New hero?',
                  actionText: 'Create account',
                  onTap: viewModel.isLoading
                      ? () {}
                      : () => context.push(AppRouter.register),
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
