import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showLostConnectDialog({
  required BuildContext context,
  VoidCallback? onRetry,
  VoidCallback? onClose,
}) {
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
      onRetry?.call();
      context.pop();
    },
    onClose: onClose,
  );
}
