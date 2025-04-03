import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/models/unity_message.dart';
import 'package:monkey_stories/models/unity_payload.dart';

final logger = Logger('UnityView');

class UnityView extends StatefulWidget {
  const UnityView({super.key});

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> with WidgetsBindingObserver {
  late UnityCubit _unityCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unityCubit = context.read<UnityCubit>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unityCubit.hideUnity();
    super.dispose();
  }

  Future<void> _handleUnityMessage(String message) async {
    await _unityCubit.handleUnityMessage(message);
  }

  void _increment() {
    final UnityMessage<CoinPayload> message = UnityMessage<CoinPayload>(
      type: 'coin',
      payload: CoinPayload(action: 'update', amount: 1),
    );
    _unityCubit.sendMessageToUnityWithResponse(message);
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
