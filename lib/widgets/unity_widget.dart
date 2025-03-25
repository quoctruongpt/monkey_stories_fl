import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';

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
    _setOrientation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    context.read<UnityCubit>().hideUnity();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOrientation();
    }
  }

  void _setOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  Future<void> _handleUnityMessage(String message) async {
    await context.read<UnityCubit>().handleUnityMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UnityCubit, UnityState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state.isUnityVisible)
                EmbedUnity(onMessageFromUnity: _handleUnityMessage),
            ],
          );
        },
      ),
    );
  }
}
