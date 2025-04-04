import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/screens/debugs/bloc_viewer_screen.dart';
import 'package:monkey_stories/screens/debugs/debug_screen.dart';
import 'package:monkey_stories/screens/debugs/logger_screen.dart';
import 'package:monkey_stories/screens/debugs/shared_prefs_screen.dart';

class DebugNavigator extends StatelessWidget {
  const DebugNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const DebugScreen()),
          GoRoute(
            path: '/logger',
            builder: (context, state) => const LoggerScreen(),
          ),
          GoRoute(
            path: '/shared-prefs',
            builder: (context, state) => const SharedPreferencesScreen(),
          ),
          GoRoute(
            path: '/bloc-viewer',
            builder: (context, state) => const BlocViewerScreen(),
          ),
        ],
      ),
    );
  }
}
