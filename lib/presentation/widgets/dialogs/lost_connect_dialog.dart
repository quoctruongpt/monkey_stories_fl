import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

Future<bool> showLostConnectDialog({required BuildContext context}) {
  final completer = Completer<bool>();

  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(
      context,
    ).translate('app.lost_connection.title'),
    messageText: AppLocalizations.of(
      context,
    ).translate('app.lost_connection.message'),
    imageAsset: 'assets/images/monkey_sad.png',
    primaryActionText: AppLocalizations.of(context).translate('app.try_again'),
    onPrimaryAction: () {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
      if (context.canPop()) {
        context.pop();
      }
    },
    onClose: () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
      if (context.canPop()) {
        context.pop();
      }
    },
  );

  return completer.future;
}
