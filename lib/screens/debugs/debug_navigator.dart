import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/screens/debugs/debug_screen.dart';

class DebugNavigator extends StatelessWidget {
  const DebugNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const DebugScreen()),
        ],
      ),
    );
  }
}
