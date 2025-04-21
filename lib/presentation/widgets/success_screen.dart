import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.title,
    this.buttonText,
    required this.onPressed,
  });

  final String title;
  final String? buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    title,
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
              text:
                  buttonText ??
                  AppLocalizations.of(
                    context,
                  ).translate('sign_up_success.action'),
              onPressed: onPressed,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
