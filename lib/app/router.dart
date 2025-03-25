import 'package:go_router/go_router.dart';
import 'package:monkey_stories/screens/home_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => MyHomePage(title: "HOme")),
  ],
);
