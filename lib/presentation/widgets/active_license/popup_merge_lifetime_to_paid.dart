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
    titleText: AppLocalizations.of(context).translate('Thông báo'),
    messageText: AppLocalizations.of(context).translate(
      'Tài khoản ba mẹ đang còn hạn sử dụng. Ba mẹ vẫn muốn kết nối với tài khoản này chứ?',
    ),
    imageAsset: 'assets/images/monkey_confused.png',
    primaryActionText: AppLocalizations.of(context).translate('Tiếp tục'),
    secondaryActionText: AppLocalizations.of(context).translate('Hủy'),
    isCloseable: false,
    onPrimaryAction: onContinue,
    onSecondaryAction: onCancel,
  );
}
