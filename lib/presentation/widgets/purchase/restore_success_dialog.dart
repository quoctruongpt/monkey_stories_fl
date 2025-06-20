import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showRestoreSuccessDialog(
  BuildContext context, {
  required VoidCallback onPrimaryAction,
}) {
  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(
      context,
    ).translate('app.payment.restore.success'),
    messageText: AppLocalizations.of(
      context,
    ).translate('app.payment.restore.success_message'),
    imageAsset: 'assets/images/max_liked.png',
    primaryActionText: AppLocalizations.of(
      context,
    ).translate('app.payment.restore.success_act'),
    onPrimaryAction: () {
      context.pop();
      onPrimaryAction();
    },
    onClose: () {
      context.pop();
      onPrimaryAction();
    },
  );
}
