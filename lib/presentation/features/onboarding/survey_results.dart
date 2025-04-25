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
              child: SingleChildScrollView(
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
                    const SurveyResultBackground(),
                    const SizedBox(height: Spacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
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

class SurveyResultBackground extends StatefulWidget {
  const SurveyResultBackground({super.key});

  @override
  State<SurveyResultBackground> createState() => _SurveyResultBackgroundState();
}

class _SurveyResultBackgroundState extends State<SurveyResultBackground> {
  double width = 0;
  double height = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Image.asset(
              'assets/images/survey_result_bg.png',
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final RenderBox? renderBox =
                      context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    setState(() {
                      width = renderBox.size.width;
                      height = renderBox.size.height;
                    });
                  }
                });
                return child;
              },
            ),

            // Text kỹ năng đọc hiểu
            Positioned(
              left: width * 0.05,
              top: height * 0.07,
              child: Text(
                AppLocalizations.of(context).translate('app.survey.skill'),
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: AppTheme.azureColor,
                ),
              ),
            ),

            // Text nội dung chất lượng
            Positioned(
              left: width * 0.28,
              top: height * 0.3,
              child: SizedBox(
                width: width * 0.22,
                height: height * 0.15,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.01,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.survey.content'),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: AppTheme.backgroundColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            // Thời gian học với Monkey Stories
            Positioned(
              left: 0,
              right: 0,
              bottom: height * 0.05,
              child: Text(
                AppLocalizations.of(context).translate('app.survey.time'),
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: AppTheme.azureColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Tháng đầu
            Positioned(
              left: width * 0.25,
              bottom: height * 0.14,
              child: SizedBox(
                width: width * 0.17,
                child: FittedBox(
                  child: Text(
                    AppLocalizations.of(context).translate('app.survey.1month'),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            // Tháng đầu
            Positioned(
              left: width * 0.47,
              bottom: height * 0.14,
              child: SizedBox(
                width: width * 0.17,
                child: FittedBox(
                  child: Text(
                    AppLocalizations.of(context).translate('app.survey.2month'),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),

            // Tháng đầu
            Positioned(
              left: width * 0.69,
              bottom: height * 0.14,
              child: SizedBox(
                width: width * 0.17,
                child: FittedBox(
                  child: Text(
                    AppLocalizations.of(context).translate('app.survey.3month'),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
