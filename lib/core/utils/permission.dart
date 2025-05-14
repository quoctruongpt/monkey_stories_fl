// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> checkCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    final result = await Permission.camera.request();

    if (result.isGranted) return true;

    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.permission.request'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.permission.camera'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.permission.open_setting'),
      onPrimaryAction: () {
        context.pop();
        openAppSettings();
      },
    );

    return false;
  }

  static Future<bool> checkPhotoLibraryPermission(BuildContext context) async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) return true;

    final result = await Permission.photos.request();

    if (result.isGranted || result.isLimited) return true;

    if (result.isPermanentlyDenied || result.isDenied) {
      showCustomNoticeDialog(
        context: context,
        titleText: AppLocalizations.of(
          context,
        ).translate('app.permission.request'),
        messageText: AppLocalizations.of(
          context,
        ).translate('app.permission.photo_library'),
        imageAsset: 'assets/images/monkey_confused.png',
        primaryActionText: AppLocalizations.of(
          context,
        ).translate('app.permission.open_setting'),
        onPrimaryAction: () {
          context.pop();
          openAppSettings();
        },
      );
    }
    return false;
  }
}
