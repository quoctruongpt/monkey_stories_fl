import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showPopupWarningMergeLifetimeToPaid({
  required BuildContext context,
  VoidCallback? onContinue,
  VoidCallback? onCancel,
}) {
  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(
      context,
    ).translate('app.active_license.warning'),
    messageText: AppLocalizations.of(
      context,
    ).translate('app.active_license.warning_merge_to_paid_account'),
    imageAsset: 'assets/images/monkey_confused.png',
    primaryActionText: AppLocalizations.of(
      context,
    ).translate('app.active_license.input_license.continue'),
    secondaryActionText: AppLocalizations.of(
      context,
    ).translate('app.active_license.cancel'),
    isCloseable: false,
    onPrimaryAction: onContinue,
    onSecondaryAction: onCancel,
  );
}
