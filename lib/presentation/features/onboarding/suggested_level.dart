import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class SuggestedLevel extends StatelessWidget {
  const SuggestedLevel({super.key});

  void _onContinuePressed(BuildContext context) {
    context.push(AppRoutePaths.surveyResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(
          // left: Spacing.md,
          // right: Spacing.md,
          bottom: Spacing.lg,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'A-D',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.azureColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.suggested_level.desc'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Image.asset('assets/images/suggest_level.png', height: 360),
                  const SizedBox(height: Spacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xxl,
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate(
                        'A-D là cấp độ tương đương với trương trình học tiếng anh lớp 4.',
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: AppButton.primary(
                text: AppLocalizations.of(
                  context,
                ).translate('app.onboarding.continue'),
                onPressed: () => _onContinuePressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
