import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/orientation/orientation_cubit.dart';
import 'package:monkey_stories/core/navigation/app_routes.dart';
import 'package:monkey_stories/core/navigation/route_observer.dart';
import 'package:monkey_stories/models/orientation.dart';
import 'package:monkey_stories/screens/home_screen.dart';
import 'package:monkey_stories/screens/result_screen.dart';
import 'package:monkey_stories/screens/unity_screen.dart';

final logger = Logger('router');
final GoRouter router = GoRouter(
  observers: [routeObserver],
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );
        return const MaterialPage(child: MyHomePage(title: 'Home'));
      },
    ),
    GoRoute(
      path: AppRoutes.result,
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.landscapeLeft,
        );
        return const MaterialPage(child: ResultScreen());
      },
    ),
    GoRoute(
      path: AppRoutes.unity,
      pageBuilder: (context, state) {
        logger.info('build');
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
  ],
);
