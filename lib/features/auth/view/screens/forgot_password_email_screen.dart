import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../viewmodel/forgot_password_email_viewmodel.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/pixel_header_card.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  late ForgotPasswordEmailViewModel _viewModel;
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ForgotPasswordEmailViewModel();

    _emailController.addListener(() {
      _viewModel.updateEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    final success = await _viewModel.sendResetCode();

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.successMessage ?? 'Success!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to code verification with email
      context.push(
        '${AppRouter.forgotPasswordCode}?email=${_viewModel.email}',
      );
    } else if (mounted && _viewModel.errorMessage != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: AuthScaffold(
        body: Consumer<ForgotPasswordEmailViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                HeightSpacer(40),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                HeightSpacer(20),

                // Header
                const PixelHeaderCard(
                  title: 'FORGOT PASSWORD',
                  subtitle: 'Enter your email to receive a magic code',
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

                HeightSpacer(32),

                // Send code button
                PrimaryButton(
                  onPressed: viewModel.isLoading ? null : _handleSendCode,
                  text: 'SEND CODE',
                  isLoading: viewModel.isLoading,
                  backgroundColor: AppColors.panelLight,
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
