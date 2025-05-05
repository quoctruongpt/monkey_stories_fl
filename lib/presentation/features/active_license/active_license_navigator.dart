import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/features/active_license/create_password.dart';
import 'package:monkey_stories/presentation/features/active_license/input_license.dart';
import 'package:monkey_stories/presentation/features/active_license/input_otp.dart';
import 'package:monkey_stories/presentation/features/active_license/input_password.dart';
import 'package:monkey_stories/presentation/features/active_license/input_phone.dart';
import 'package:monkey_stories/presentation/features/active_license/last_login_info.dart';
import 'package:monkey_stories/presentation/features/active_license/phone_info.dart';
import 'package:monkey_stories/presentation/features/active_license/success.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';

class ActiveLicenseNavigator extends StatelessWidget {
  const ActiveLicenseNavigator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrientationWrapper(
      orientation: AppOrientation.portrait,
      child: BlocProvider(
        create: (context) => sl<ActiveLicenseCubit>(),
        child: child,
      ),
    );
  }
}

final ShellRoute activeLicenseRoutes = ShellRoute(
  builder: (context, state, child) => ActiveLicenseNavigator(child: child),
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
