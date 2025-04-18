import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/monkey_ask.png', width: 116, height: 154),
        const SizedBox(height: Spacing.sm),
        Text(
          AppLocalizations.of(context).translate('app.forgot_password.title'),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: Spacing.sm),

        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: Spacing.xxl),
      ],
    );
  }
}
