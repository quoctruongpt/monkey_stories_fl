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
  bool _isExited = false;

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

  void _trackPush() {
    _isExited = false;
    widget.onTrackPush?.call();
  }

  void _trackExit() {
    if (_isExited) {
      return;
    }
    _isExited = true;
    widget.onTrackExit?.call();
  }

  @override
  void didPush() {
    _trackPush();
  }

  @override
  void didPopNext() {
    _trackPush();
  }

  @override
  void didPop() {
    _trackExit();
  }

  @override
  void didPushNext() {
    _trackExit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        RouteTracker.currentRouteName == widget.routeName) {
      widget.onTrackExit?.call();
      return;
    }
  }

  @override
  void dispose() {
    _trackExit();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
