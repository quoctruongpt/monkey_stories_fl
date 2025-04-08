import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class TextAndAction extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionTap;
  const TextAndAction({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor),
        children: <TextSpan>[
          TextSpan(text: text),
          TextSpan(
            text: actionText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textBlueColor),
            recognizer: TapGestureRecognizer()..onTap = onActionTap,
          ),
        ],
      ),
    );
  }
}
