import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
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
    this.textCapitalization,
    this.labelText,
    this.labelTopText,
    this.labelTopIcon,
    this.onTap,
    this.keyboardType,
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
  final TextCapitalization? textCapitalization;
  final String? labelText;
  final String? labelTopText;
  final Widget? labelTopIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelTopText != null)
              Column(
                children: [
                  Row(
                    children: [
                      labelTopIcon ?? const SizedBox.shrink(),
                      const SizedBox(width: Spacing.sm),
                      Text(labelTopText!),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                ],
              ),
            TextField(
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              focusNode: focusNode,
              controller: controller,
              onChanged: onChanged,
              obscureText: obscureText ?? true,
              style: const TextStyle(fontSize: 20),
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                errorText:
                    errorText != null && errorText!.isEmpty ? null : errorText,
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
        ),
      ),
    );
  }
}
