import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/purchase/drag_handle.dart';

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
          const DragHandle(),
          const SizedBox(height: Spacing.lg),
          Text(
            AppLocalizations.of(context).translate('app.purchase.footer.terms'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: Spacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                AppLocalizations.of(context).translate(
                  Platform.isIOS ? 'app.terms.ios' : 'app.terms.android',
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textGrayColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        (context) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height *
                0.7, // Giới hạn 70% chiều cao màn hình
          ),
          child: const FractionallySizedBox(
            widthFactor: 1, // full width
            child: TermsBottomSheet(),
          ),
        ),
  );
}
