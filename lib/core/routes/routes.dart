import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/presentation/screens/create_profile/choose_level.dart';
import 'package:monkey_stories/presentation/screens/create_profile/choose_year_of_birth.dart';
import 'package:monkey_stories/presentation/screens/create_profile/create_profile_loading.dart';
import 'package:monkey_stories/presentation/screens/create_profile/input_name_screen.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/forgot_password_navigator.dart';
import 'package:monkey_stories/presentation/screens/sign_up/sign_up_success_screen.dart';
import 'package:monkey_stories/presentation/screens/splash/splash_screen.dart';
import 'package:monkey_stories/presentation/screens/unity/unity_screen.dart';
import 'package:monkey_stories/presentation/screens/home_screen.dart';
import 'package:monkey_stories/presentation/screens/sign_in/login_screen.dart';
import 'package:monkey_stories/presentation/screens/result_screen.dart';
import 'package:monkey_stories/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';

final logger = Logger('router');
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GoRouter router = GoRouter(
  observers: [routeObserver],
  initialLocation: AppRoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.splash,
      name: AppRouteNames.splash,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SplashScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.home,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: MyHomePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.result,
      name: AppRouteNames.result,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.landscapeLeft,
          child: ResultScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.unity,
      name: AppRouteNames.unity,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.landscapeLeft,
          child: UnityScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.login,
      name: AppRouteNames.login,
      builder: (context, state) {
        final String? initialUsername = state.uri.queryParameters['username'];
        final String? initialPassword = state.uri.queryParameters['password'];
        return LoginScreenProvider(
          initialUsername: initialUsername,
          initialPassword: initialPassword,
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.signUp,
      name: AppRouteNames.signUp,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SignUpScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.signUpSuccess,
      name: AppRouteNames.signUpSuccess,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SignUpSuccessScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.createProfileInputName,
      name: AppRouteNames.createProfileInputName,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileInputNameScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileInputDateOfBirth,
      name: AppRouteNames.createProfileInputDateOfBirth,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileChooseYearOfBirthScreen(name: name),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileChooseLevel,
      name: AppRouteNames.createProfileChooseLevel,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        final int yearOfBirth = int.parse(
          state.uri.queryParameters['yearOfBirth'] ?? '0',
        );
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ChooseLevelScreen(name: name, yearOfBirth: yearOfBirth),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileLoading,
      name: AppRouteNames.createProfileLoading,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        final int yearOfBirth = int.parse(
          state.uri.queryParameters['yearOfBirth'] ?? '0',
        );
        final int levelId = int.parse(
          state.uri.queryParameters['levelId'] ?? '0',
        );
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileLoadingScreen(
            name: name,
            yearOfBirth: yearOfBirth,
            levelId: levelId,
          ),
        );
      },
    ),

    forgotPasswordRoutes,
  ],
);
