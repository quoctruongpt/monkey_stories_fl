import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/features/active_license/create_password.dart';
import 'package:monkey_stories/presentation/features/active_license/input_license.dart';
import 'package:monkey_stories/presentation/features/active_license/input_otp.dart';
import 'package:monkey_stories/presentation/features/active_license/input_password.dart';
import 'package:monkey_stories/presentation/features/active_license/input_phone.dart';
import 'package:monkey_stories/presentation/features/active_license/last_login_info.dart';
import 'package:monkey_stories/presentation/features/active_license/phone_info.dart';
import 'package:monkey_stories/presentation/features/active_license/success.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';

class ActiveLicenseNavigator extends StatelessWidget {
  const ActiveLicenseNavigator({
    super.key,
    required this.child,
    this.licenseInfo,
    this.isUsernameCrm = false,
  });

  final Widget child;
  final LicenseCodeInfoEntity? licenseInfo;
  final bool? isUsernameCrm;

  @override
  Widget build(BuildContext context) {
    return OrientationWrapper(
      orientation: AppOrientation.portrait,
      child: BlocProvider(
        create: (context) => sl<ActiveLicenseCubit>()..init(licenseInfo),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
              listenWhen:
                  (previous, current) =>
                      current.linkAccountError != null &&
                      current.linkAccountError != previous.linkAccountError,
              listener: _linkAccountErrorListener,
            ),
            BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
              listenWhen: (previous, current) => current.isSuccess == true,
              listener: _linkAccountSuccessListener,
            ),
            BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
              listenWhen:
                  (previous, current) =>
                      current.isShowMergeToLifetimeAccountWarning == true &&
                      current.isShowMergeToLifetimeAccountWarning !=
                          previous.isShowMergeToLifetimeAccountWarning,
              listener: _showMergeToLifetimeAccountWarningListener,
            ),
            BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
              listenWhen: (previous, current) => current.isDone == true,
              listener: _handleSuccessListener,
            ),
          ],
          child: child,
        ),
      ),
    );
  }

  void _linkAccountErrorListener(
    BuildContext context,
    ActiveLicenseState state,
  ) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.active_license.error'),
      messageText: AppLocalizations.of(
        context,
      ).translate(state.linkAccountError),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(context).translate('Ok'),
      isCloseable: false,
      onPrimaryAction: () {
        context.pop();
        context.go(
          isUsernameCrm == true
              ? AppRoutePaths.login
              : AppRoutePaths.inputLicense,
        );
        context.read<ActiveLicenseCubit>().clearLinkAccountError();
      },
    );
  }

  void _linkAccountSuccessListener(
    BuildContext context,
    ActiveLicenseState state,
  ) {
    context.go(AppRoutePaths.activeLicenseSuccess);
  }

  void _showMergeToLifetimeAccountWarningListener(
    BuildContext context,
    ActiveLicenseState state,
  ) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.active_license.warning'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.active_license.warning_merge_to_lifetime_account'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.active_license.input_license.continue'),
      isCloseable: false,
      onPrimaryAction: () {
        context.read<ActiveLicenseCubit>().closeMergeToLifetimeAccountWarning();
        context.pop();
      },
    );
  }

  void _handleSuccessListener(BuildContext context, ActiveLicenseState state) {
    context.go(AppRoutePaths.home);
  }
}

final ShellRoute activeLicenseRoutes = ShellRoute(
  builder: (context, state, child) {
    final extraMap = state.extra as Map<String, dynamic>?;
    final licenseInfo = extraMap?['licenseInfo'] as LicenseCodeInfoEntity?;
    final isUsernameCrm = extraMap?['isUsernameCrm'] as bool?;
    return ActiveLicenseNavigator(
      licenseInfo: licenseInfo,
      isUsernameCrm: isUsernameCrm,
      child: child,
    );
  },
  routes: [
    GoRoute(
      path: AppRoutePaths.inputLicense,
      name: AppRouteNames.inputLicense,
      builder: (context, state) => const InputLicense(),
    ),
    GoRoute(
      path: AppRoutePaths.lastLoginInfo,
      name: AppRouteNames.lastLoginInfo,
      builder: (context, state) => const ActiveLicenseLastLoginInfo(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicenseInputPhone,
      name: AppRouteNames.activeLicenseInputPhone,
      builder: (context, state) => const ActiveLicenseInputPhone(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicensePhoneInfo,
      name: AppRouteNames.activeLicensePhoneInfo,
      builder: (context, state) => const ActiveLicensePhoneInfo(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicenseInputPassword,
      name: AppRouteNames.activeLicenseInputPassword,
      builder: (context, state) => const ActiveLicenseInputPassword(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicenseCreatePassword,
      name: AppRouteNames.activeLicenseCreatePassword,
      builder: (context, state) => const ActiveLicenseCreatePassword(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicenseInputOtp,
      name: AppRouteNames.activeLicenseInputOtp,
      builder: (context, state) => const ActiveLicenseInputOtp(),
    ),
    GoRoute(
      path: AppRoutePaths.activeLicenseSuccess,
      name: AppRouteNames.activeLicenseSuccess,
      builder: (context, state) => const ActiveLicenseSuccess(),
    ),
  ],
);
