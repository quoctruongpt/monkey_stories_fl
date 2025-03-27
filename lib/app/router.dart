import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/orientation/orientation_cubit.dart';
import 'package:monkey_stories/models/orientation.dart';
import 'package:monkey_stories/screens/home_screen.dart';
import 'package:monkey_stories/screens/result_screen.dart';

final logger = Logger("router");
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.portrait,
        );
        return MaterialPage(child: MyHomePage(title: "Home"));
      },
    ),
    GoRoute(
      path: '/result',
      pageBuilder: (context, state) {
        context.read<OrientationCubit>().lockOrientation(
          context,
          AppOrientation.landscapeLeft,
        );
        return MaterialPage(child: ResultScreen());
      },
    ),
  ],
);
