import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    super.key,
    this.controller,
    required this.onChanged,
    this.errorText,
    this.hintText,
    this.passwordValidText,
    this.obscureText = true,
    this.onObscureTextToggle,
    this.isPasswordValid = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final void Function(String) onChanged;
  final String? errorText;
  final String? hintText;
  final String? passwordValidText;
  final bool? obscureText;
  final VoidCallback? onObscureTextToggle;
  final bool isPasswordValid;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFieldWidget(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          errorText: errorText,
          hintText: hintText,
          obscureText: obscureText ?? true,
          isValid: isPasswordValid,
          validText: passwordValidText,
          suffixIcon: IconButton(
            onPressed: onObscureTextToggle,
            icon: Icon(
              obscureText == true
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
