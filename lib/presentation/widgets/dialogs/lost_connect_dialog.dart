import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showLostConnectDialog({
  required BuildContext context,
  VoidCallback? onRetry,
  VoidCallback? onClose,
}) {
  showCustomNoticeDialog(
    context: context,
    titleText: 'app.lost_connection.title',
    messageText: 'app.lost_connection.message',
    imageAsset: 'assets/images/monkey_sad.png',
    primaryActionText: 'app.try_again',
    onPrimaryAction: () {
      onRetry?.call();
      context.pop();
    },
    onClose: onClose,
  );
}
