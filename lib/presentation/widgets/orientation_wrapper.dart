import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';

final logger = Logger('OrientationWrapper');

class OrientationWrapper extends StatefulWidget {
  final AppOrientation orientation;
  final Widget child;

  const OrientationWrapper({
    super.key,
    required this.orientation,
    required this.child,
  });

  @override
  State<OrientationWrapper> createState() => _OrientationWrapperState();
}

class _OrientationWrapperState extends State<OrientationWrapper>
    with RouteAware {
  void _setOrientation() {
    logger.info('Setting orientation: ${widget.orientation}');
    context.read<AppCubit>().setOrientation(widget.orientation);
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
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _setOrientation();
  }

  @override
  void didPopNext() {
    _setOrientation(); // khi quay lại màn này
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
