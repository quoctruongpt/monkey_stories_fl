import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

class ChangePasswordSuccess extends StatelessWidget {
  const ChangePasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SuccessScreen(
        title: AppLocalizations.of(
          context,
        ).translate('app.change_password.success'),
        onPressed: () {
          context.go(AppRoutePaths.home);
        },
        buttonText: AppLocalizations.of(
          context,
        ).translate('app.change_password.success_button'),
      ),
    );
  }
}
