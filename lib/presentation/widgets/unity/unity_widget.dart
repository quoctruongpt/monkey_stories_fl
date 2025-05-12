import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/widgets/profile/list_profile_dialog.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';

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
  }

  @override
  void initState() {
    super.initState();
    _unityCubit = context.read<UnityCubit>();
    WidgetsBinding.instance.addObserver(this);
    _unityCubit.registerHandler(MessageTypes.openListProfile, (
      UnityMessageEntity message,
    ) async {
      showListProfileDialog(context);
      return null;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unityCubit.hideUnity();
    _unityCubit.unregisterHandler(MessageTypes.openListProfile);
    super.dispose();
  }

  Future<void> _handleUnityMessage(String message) async {
    await _unityCubit.handleUnityMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(body: EmbedUnity(onMessageFromUnity: _handleUnityMessage)),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent('').convert({
                  'type': MessageTypes.openListProfile,
                  'payload': null,
                }),
              );
            },
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
