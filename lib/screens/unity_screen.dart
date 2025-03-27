import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/core/navigation/route_observer.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/models/unity_message.dart';

final logger = Logger('UnityScreen');

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<UnityCubit>().registerHandler(MessageTypes.closeUnity, (
      UnityMessage message,
    ) async {
      context.pop();
      return null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPush() {
    final message = UnityMessage(
      type: MessageTypes.openUnity,
      payload: {'destination': 'map_lesson'},
    );
    context.read<UnityCubit>().sendMessageToUnity(message);
    context.read<UnityCubit>().showUnity();
  }

  @override
  void didPopNext() {
    context.read<UnityCubit>().showUnity();
  }

  @override
  void didPushNext() {
    context.read<UnityCubit>().hideUnity();
  }

  @override
  void didPop() {
    context.read<UnityCubit>().hideUnity();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
