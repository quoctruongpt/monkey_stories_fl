import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    required this.onChanged,
    this.errorText,
    this.hintText,
    this.obscureText = true,
    this.suffixIcon,
    this.isValid,
    this.validText,
    this.focusNode,
  });

  final TextEditingController? controller;
  final void Function(String) onChanged;
  final String? errorText;
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final bool? isValid;
  final String? validText;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText ?? true,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.textGrayLightColor),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    isValid == true
                        ? AppTheme.successColor
                        : AppTheme.textGrayLightColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    isValid == true
                        ? AppTheme.successColor
                        : AppTheme.textGrayLightColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.errorColor),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.errorColor),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            errorMaxLines: 2,
          ),
        ),

        isValid == true && validText != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.sm),

                Text(
                  validText!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}

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
