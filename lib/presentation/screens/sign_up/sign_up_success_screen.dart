import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void handleContinue() {
      context.push(AppRoutePaths.createProfileInputName);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.lg,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('sign_up_success.title'),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),
                    Transform.scale(
                      scale: 1.3,
                      child: Lottie.asset(
                        'assets/lottie/monkey_toss_stars.lottie',
                        decoder: customDecoder,
                      ),
                    ),
                  ],
                ),
              ),
              AppButton.primary(
                text: AppLocalizations.of(
                  context,
                ).translate('sign_up_success.act'),
                onPressed: handleContinue,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
