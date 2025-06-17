import 'package:flutter/material.dart';
import 'package:monkey_stories/core/routes/routes.dart';

class ScreenTracker extends StatefulWidget {
  const ScreenTracker({
    super.key,
    this.onTrackExit,
    this.onTrackPush,
    required this.routeName,
    required this.child,
  });

  final VoidCallback? onTrackExit;
  final VoidCallback? onTrackPush;
  final String routeName;
  final Widget child;

  @override
  State<ScreenTracker> createState() => _ScreenTrackerState();
}

class _ScreenTrackerState extends State<ScreenTracker>
    with WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() {
    widget.onTrackPush?.call();
  }

  @override
  void didPop() {
    widget.onTrackExit?.call();
  }

  @override
  void didPushNext() {
    widget.onTrackExit?.call();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        RouteTracker.currentRouteName == widget.routeName) {
      widget.onTrackExit?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
