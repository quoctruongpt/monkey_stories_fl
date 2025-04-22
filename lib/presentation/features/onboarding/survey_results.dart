import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class SurveyResults extends StatelessWidget {
  const SurveyResults({super.key});

  void _onContinuePressed(BuildContext context) {
    context.go(AppRoutePaths.onboardLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Spacing.md,
          right: Spacing.md,
          bottom: Spacing.lg,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('app.survey_results.title'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.azureColor,
                    ),
                  ),
                  Html(
                    data: AppLocalizations.of(
                      context,
                    ).translate('app.survey_results.desc'),
                    style: {
                      'b': Style(
                        color: AppTheme.pinkColor,
                        fontWeight: FontWeight.w900,
                      ),
                      'p': Style(
                        fontSize: FontSize.large,
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                  Image.asset('assets/images/survey_result.png'),
                  const SizedBox(height: Spacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.survey_results.note'),
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
            AppButton.primary(
              text: AppLocalizations.of(
                context,
              ).translate('app.onboarding.continue'),
              onPressed: () => _onContinuePressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
