import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showPermissionDeniedDialog(BuildContext context) {
  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(context).translate('app.notice'),
    messageText: AppLocalizations.of(
      context,
    ).translate('app.permission.message'),
    onPrimaryAction: () {
      context.pop();
      context.go(AppRoutePaths.vip);
    },
    primaryActionText: AppLocalizations.of(
      context,
    ).translate('app.permission.act'),
    imageAsset: 'assets/images/monkey_confused.png',
  );
}
