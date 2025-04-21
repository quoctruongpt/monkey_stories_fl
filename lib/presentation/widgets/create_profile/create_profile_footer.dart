import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class CreateProfileFooter extends StatelessWidget {
  const CreateProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      child: Text(
        AppLocalizations.of(context).translate('app.create_profile.footer'),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppTheme.textSecondaryColor,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
