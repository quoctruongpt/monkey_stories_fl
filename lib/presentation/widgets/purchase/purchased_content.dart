import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/features/purchased/purchased.dart';

class PurchasedContent extends StatelessWidget {
  const PurchasedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...listContent.map(
          (e) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.azureColor,
                    size: 24,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context).translate(e),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ],
    );
  }
}
