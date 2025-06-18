import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

Widget buildYearButton(
  BuildContext context,
  int year,
  bool isSelected,
  VoidCallback onPressed, {
  String? customText,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color:
            isSelected
                ? AppTheme.primaryColor
                : AppTheme.buttonPrimaryDisabledBackground,
        width: 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.md,
      ),
      backgroundColor:
          isSelected ? AppTheme.blueLightColor : Colors.transparent,
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        customText ?? year.toString(),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color:
              isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
        ),
      ),
    ),
  );
}
