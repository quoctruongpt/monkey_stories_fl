import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/features/onboarding/choose_language.dart';
import 'package:monkey_stories/presentation/features/onboarding/choose_level.dart';
import 'package:monkey_stories/presentation/features/onboarding/choose_year_of_birth.dart';
import 'package:monkey_stories/presentation/features/onboarding/leave_contact.dart';
import 'package:monkey_stories/presentation/features/onboarding/obd_purchase.dart';
import 'package:monkey_stories/presentation/features/onboarding/onboard_loading.dart';
import 'package:monkey_stories/presentation/features/onboarding/suggested_level.dart';

class OBDDNavigator extends StatelessWidget {
  const OBDDNavigator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingCubit>(),
      child: child,
    );
  }
}

final ShellRoute obdRoutes = ShellRoute(
  builder: (context, state, child) => OBDDNavigator(child: child),
  routes: [
    GoRoute(
      path: AppRoutePaths.chooseYearOfBirthOBD,
      name: AppRouteNames.chooseYearOfBirthOBD,
      builder: (context, state) => const ChooseYearOfBirthOBD(),
    ),
    GoRoute(
      path: AppRoutePaths.chooseLevelOBD,
      name: AppRouteNames.chooseLevelOBD,
      builder: (context, state) => const ChooseLevelOBD(),
    ),
    GoRoute(
      path: AppRoutePaths.chooseLanguage,
      name: AppRouteNames.chooseLanguage,
      builder: (context, state) => const ChooseLanguage(),
    ),
    GoRoute(
      path: AppRoutePaths.suggestedLevel,
      name: AppRouteNames.suggestedLevel,
      builder: (context, state) => const SuggestedLevel(),
    ),
    GoRoute(
      path: AppRoutePaths.obdPurchase,
      name: AppRouteNames.obdPurchase,
      builder: (context, state) => const ObdPurchaseProvider(),
    ),
    GoRoute(
      path: AppRoutePaths.leaveContact,
      name: AppRouteNames.leaveContact,
      builder: (context, state) => const LeaveContact(),
    ),
    GoRoute(
      path: AppRoutePaths.onboardLoading,
      name: AppRouteNames.onboardLoading,
      builder: (context, state) => const OnboardLoading(),
    ),
  ],
);
