import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/view/widgets/auth_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: widget.controller,
      label: widget.label,
      obscureText: _obscure,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textMuted,
        ),
        onPressed: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
      ),
    );
  }
}
