// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:monkey_stories/presentation/features/debugs/bloc_viewer_screen.dart';
import 'package:monkey_stories/presentation/features/debugs/debug_screen.dart';
import 'package:monkey_stories/presentation/features/debugs/files_screen.dart';
import 'package:monkey_stories/presentation/features/debugs/logger_screen.dart';
import 'package:monkey_stories/presentation/features/debugs/network_logger_screen.dart';
import 'package:monkey_stories/presentation/features/debugs/remote_config.dart';
import 'package:monkey_stories/presentation/features/debugs/shared_prefs_screen.dart';

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
          GoRoute(
            path: '/network-logger',
            builder: (context, state) => const NetworkLoggerScreen(),
          ),
          GoRoute(
            path: '/remote-config',
            builder: (context, state) => const RemoteConfigScreen(),
          ),
          GoRoute(
            path: '/files',
            builder: (context, state) => const FilesScreen(),
          ),
        ],
      ),
    );
  }
}
