import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class TermsBottomSheet extends StatelessWidget {
  const TermsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightGrayColor,
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            AppLocalizations.of(context).translate('app.purchase.footer.terms'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            AppLocalizations.of(
              context,
            ).translate(Platform.isIOS ? 'app.terms.ios' : 'app.terms.android'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textGrayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

void showTermsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => const FractionallySizedBox(
          widthFactor: 1, // full width
          child: TermsBottomSheet(),
        ),
  );
}
