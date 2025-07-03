import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showDeleteDataDialog(BuildContext context) {
  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(
      context,
    ).translate('app.setting.delete_data_title'),
    titleColor: AppTheme.errorColor,
    messageText: AppLocalizations.of(
      context,
    ).translate('app.setting.delete_data_message'),
    imageAsset: 'assets/images/max_warning.png',
    primaryActionText: AppLocalizations.of(
      context,
    ).translate('app.setting.delete_data_button'),
    onPrimaryAction: () {
      context.pop();
      context.read<AppCubit>().deleteDataDownloaded();
    },
    secondaryActionText: AppLocalizations.of(context).translate('app.cancel'),
    onSecondaryAction: () {
      context.pop();
    },
  );
}
