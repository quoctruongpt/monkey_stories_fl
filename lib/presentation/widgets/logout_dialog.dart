import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showLogoutDialog(BuildContext context) {
  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(context).translate('Đăng xuất'),
    titleColor: AppTheme.errorColor,
    messageText: AppLocalizations.of(
      context,
    ).translate('Bạn chắc chắn muốn đăng xuất tài khoản này khỏi Monkey?'),
    imageAsset: 'assets/images/max_drink.png',
    primaryActionText: AppLocalizations.of(context).translate('Đăng xuất'),
    onPrimaryAction: () {
      context.read<UserCubit>().logout();
      context.go(AppRoutePaths.login);
    },
    secondaryActionText: AppLocalizations.of(context).translate('Trở lại'),
    onSecondaryAction: () {
      context.pop();
    },
  );
}
