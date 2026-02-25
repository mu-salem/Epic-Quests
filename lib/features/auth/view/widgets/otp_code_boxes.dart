import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class OtpCodeBoxes extends StatefulWidget {
  const OtpCodeBoxes({
    super.key,
    required this.length,
    required this.onChanged,
    this.enabled = true,
    this.hasError = false,
  });

  final int length;
  final Function(String) onChanged;
  final bool enabled;
  final bool hasError;

  @override
  State<OtpCodeBoxes> createState() => _OtpCodeBoxesState();
}

class _OtpCodeBoxesState extends State<OtpCodeBoxes> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _previousValues; // Track previous values

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _previousValues = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getCode() {
    return _controllers.map((c) => c.text).join();
  }

  void _handleTextChanged(int index, String value) {
    final previousValue = _previousValues[index];

    if (value.isEmpty) {
      // On delete/backspace:
      // If previous value was not empty (user just deleted from this field)
      if (previousValue.isNotEmpty) {
        // Just cleared current field - stay here
        _previousValues[index] = '';
      } else if (index > 0) {
        // Current field was already empty - clear previous and move focus
        _controllers[index - 1].clear();
        _previousValues[index - 1] = '';
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      _previousValues[index] = value;
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus
        _focusNodes[index].unfocus();
      }
    } else if (value.length > 1) {
      // Handle paste - split digits across boxes
      final digits = value.split('').where((c) => c.isNotEmpty).toList();
      for (int i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
        _previousValues[i] = digits[i];
      }
      // Focus last filled box or unfocus if complete
      final lastIndex = (digits.length - 1).clamp(0, widget.length - 1);
      if (lastIndex < widget.length - 1) {
        _focusNodes[lastIndex + 1].requestFocus();
      } else {
        _focusNodes[lastIndex].unfocus();
      }
    }

    widget.onChanged(_getCode());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) => _buildBox(index)),
    );
  }

  Widget _buildBox(int index) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          children: [
            // Shadow/border effect
            Positioned(
              top: 4,
              left: 4,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.hasError
                      ? AppColors.error.withValues(alpha: 0.3)
                      : AppColors.accent.withValues(alpha: 0.3),
                  border: Border.all(
                    color: widget.hasError ? AppColors.error : AppColors.accent,
                    width: 2,
                  ),
                ),
              ),
            ),

            // Main box
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? AppColors.panelLight
                    : AppColors.panelLight.withValues(alpha: 0.5),
                border: Border.all(
                  color: widget.hasError
                      ? AppColors.error
                      : (_focusNodes[index].hasFocus
                            ? AppColors.accent
                            : AppColors.textSecondary),
                  width: 3,
                ),
              ),
              child: Center(
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => _handleTextChanged(index, value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
