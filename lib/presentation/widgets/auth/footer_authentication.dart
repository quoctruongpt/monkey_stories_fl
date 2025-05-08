import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/horizontal_line_text.dart';
import 'package:monkey_stories/presentation/widgets/auth/social_login_button.dart';
import 'package:monkey_stories/presentation/widgets/base/text_and_action.dart';

class FooterAuthentication extends StatelessWidget {
  const FooterAuthentication({
    super.key,
    required this.textOnLine,
    required this.actionDescText,
    required this.actionText,
    required this.onFacebookPress,
    required this.onGooglePress,
    required this.onApplePress,
    required this.onActionPress,
  });

  final String textOnLine;
  final String actionDescText;
  final String actionText;
  final VoidCallback onFacebookPress;
  final VoidCallback onGooglePress;
  final VoidCallback onApplePress;
  final VoidCallback onActionPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: HorizontalLineText(text: textOnLine),
        ),

        const SizedBox(height: Spacing.xl),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SocialLoginButton(
                backgroundColor: Colors.blue.shade700,
                iconData: Icons.facebook,
                onPressed: onFacebookPress,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: SocialLoginButton(
                backgroundColor: Colors.white,
                googleIconAsset: 'assets/icons/svg/google.svg',
                onPressed: onGooglePress,
                isGoogle: true,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Platform.isIOS
                ? Expanded(
                  child: SocialLoginButton(
                    backgroundColor: Colors.black,
                    iconData: Icons.apple,
                    onPressed: onApplePress,
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),

        const SizedBox(height: Spacing.lg),

        Center(
          child: TextAndAction(
            text: actionDescText,
            actionText: actionText,
            onActionTap: onActionPress,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
