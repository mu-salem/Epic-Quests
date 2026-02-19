import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../viewmodel/forgot_password_code_viewmodel.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/pixel_header_card.dart';

class ForgotPasswordCodeScreen extends StatefulWidget {
  const ForgotPasswordCodeScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ForgotPasswordCodeScreen> createState() => _ForgotPasswordCodeScreenState();
}

class _ForgotPasswordCodeScreenState extends State<ForgotPasswordCodeScreen> {
  late ForgotPasswordCodeViewModel _viewModel;
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ForgotPasswordCodeViewModel(email: widget.email);

    _codeController.addListener(() {
      _viewModel.updateCode(_codeController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyCode() async {
    final success = await _viewModel.verifyCode();

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.successMessage ?? 'Success!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to reset password with email and code
      context.push(
        '${AppRouter.resetPassword}?email=${widget.email}&code=${_viewModel.code}',
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
        body: Consumer<ForgotPasswordCodeViewModel>(
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
                  title: 'ENTER CODE',
                  subtitle: 'Check your scroll for the magic code',
                ),

                HeightSpacer(40),

                // Code field
                AuthTextField(
                  controller: _codeController,
                  label: 'VERIFICATION CODE',
                  hint: '123456',
                  keyboardType: TextInputType.number,
                  errorText: viewModel.codeError,
                  enabled: !viewModel.isLoading,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                HeightSpacer(32),

                // Verify button
                PrimaryButton(
                  onPressed: viewModel.isLoading ? null : _handleVerifyCode,
                  text: 'VERIFY',
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
