import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/orientation/orientation_cubit.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/presentation/screens/splash/splash_screen.dart';
import 'package:monkey_stories/presentation/screens/unity/unity_screen.dart';
import 'package:monkey_stories/screens/home_screen.dart';
import 'package:monkey_stories/screens/login_screen.dart';
import 'package:monkey_stories/screens/result_screen.dart';
import 'package:monkey_stories/screens/sign_up_screen.dart';
import 'package:monkey_stories/screens/year_ob_birth_screen.dart';

final logger = Logger('router');
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GoRouter router = GoRouter(
  observers: [routeObserver],
  initialLocation: AppRoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.splash,
      name: AppRouteNames.splash,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );
        return const MaterialPage(child: SplashScreen());
      },
    ),
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.home,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );
        return const MaterialPage(child: MyHomePage());
      },
    ),
    GoRoute(
      path: AppRoutePaths.result,
      name: AppRouteNames.result,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.landscapeLeft,
        );
        return const MaterialPage(child: ResultScreen());
      },
    ),
    GoRoute(
      path: AppRoutePaths.unity,
      name: AppRouteNames.unity,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.landscapeLeft,
        );

        return const MaterialPage(child: UnityScreen());
      },
      redirect: (context, state) {
        logger.info('redirect');
        return null;
      },
    ),
    GoRoute(
      path: AppRoutePaths.yearOfBirth,
      name: AppRouteNames.yearOfBirth,
      pageBuilder: (context, state) {
        return const MaterialPage(child: YearOfBirthScreen());
      },
    ),
    GoRoute(
      path: AppRoutePaths.login,
      name: AppRouteNames.login,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );

        final String? initialUsername = state.uri.queryParameters['username'];
        return MaterialPage(
          key: ValueKey('login-${initialUsername ?? ''}'),
          child: LoginScreenProvider(initialUsername: initialUsername),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.signUp,
      name: AppRouteNames.signUp,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );
        return const MaterialPage(child: SignUpScreen());
      },
    ),
  ],
);
