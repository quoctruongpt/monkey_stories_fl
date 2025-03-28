import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/models/unity_message.dart';

final logger = Logger('UnityView');

class UnityView extends StatefulWidget {
  const UnityView({super.key});

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<UnityCubit>().hideUnity();
    super.dispose();
  }

  Future<void> _handleUnityMessage(String message) async {
    await context.read<UnityCubit>().handleUnityMessage(message);
  }

  void _increment() {
    final UnityMessage message = UnityMessage(
      type: 'coin',
      payload: {'action': 'update', 'amount': 1},
    );
    context.read<UnityCubit>().sendMessageToUnityWithResponse(message);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    logger.info(orientation);
    return Scaffold(
      body: BlocBuilder<UnityCubit, UnityState>(
        builder: (context, state) {
          return Stack(
            children: [
              EmbedUnity(onMessageFromUnity: _handleUnityMessage),
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    FilledButton(onPressed: _increment, child: const Text('+')),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
