import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

class TextFieldWithSuffixIcon extends StatelessWidget {
  const TextFieldWithSuffixIcon({
    super.key,
    this.controller,
    required this.onChanged,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.isValid,
    this.validText,
    this.focusNode,
    this.onErrorPressed,
    this.isShowIcon = false,
    this.textCapitalization,
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
  final VoidCallback? onErrorPressed;
  final bool? isShowIcon;
  final TextCapitalization? textCapitalization;
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      controller: controller,
      errorText: errorText != null && errorText!.isNotEmpty ? errorText : null,
      hintText: hintText,
      obscureText: obscureText,
      suffixIcon:
          suffixIcon ??
          (isShowIcon == true
              ? isValid == false
                  ? IconButton(
                    onPressed: onErrorPressed,
                    icon: const Icon(
                      Icons.cancel,
                      color: AppTheme.textSecondaryColor,
                    ),
                  )
                  : const Icon(
                    Icons.check_circle,
                    size: 24,
                    color: AppTheme.successColor,
                  )
              : null),
      isValid: isValid,
      validText: validText,
      focusNode: focusNode,
    );
  }
}
