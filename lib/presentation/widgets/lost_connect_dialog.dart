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
    titleText: 'Lỗi kết nối',
    messageText: 'Vui lòng kiểm tra lại kết nối mạng của bạn.',
    imageAsset: 'assets/images/monkey_sad.png',
    primaryActionText: 'Thử lại',
    onPrimaryAction: () {
      onRetry?.call();
      context.pop();
    },
    onClose: onClose,
  );
}
