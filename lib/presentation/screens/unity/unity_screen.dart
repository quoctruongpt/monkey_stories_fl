import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core1/constants/unity_constants.dart';
import 'package:monkey_stories/core1/routes/routes.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

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
      UnityMessageEntity message,
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
    final message = const UnityMessageEntity(
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
