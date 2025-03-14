import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:monkey_stories/constants/unity.dart';
import 'package:monkey_stories/providers/unity_provider.dart';
import 'package:monkey_stories/services/unity_service.dart';
import 'package:monkey_stories/types/unity.dart';
import 'package:provider/provider.dart';

class UnityView extends StatefulWidget {
  const UnityView({Key? key}) : super(key: key);

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> with WidgetsBindingObserver {
  late UnityProvider _unityProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _unityProvider = Provider.of<UnityProvider>(context, listen: false);
    _setOrientation();
    _unityProvider.showUnity();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _unityProvider.hideUnity();
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

  // Unified message handler that uses the provider's handler
  Future<void> _handleUnityMessage(String message) async {
    print("Unity message: $message");
    try {
      await _unityProvider.handleUnityMessage(message);
    } catch (e) {
      print('Error handling Unity message in view: $e');
    }
  }

  Future<void> _sendMessageToUnity() async {
    try {
      final message = UnityMessage(
        type: MessageTypes.coin,
        payload: {'action': 'get'},
      );

      final response = await _unityProvider.sendMessageToUnityWithResponse(
        message,
      );
      print("Response from Unity: $response");
    } catch (e) {
      print('Error sending message to Unity: $e');
    }
  }

  void _sendDirectMessage() {
    try {
      sendToUnity("FlutterObject", "ReciveText", "Xin chao");
    } catch (e) {
      print('Error sending direct message to Unity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UnityProvider>(
        builder: (context, unityProvider, child) {
          return Stack(
            children: [
              if (unityProvider.isUnityVisible)
                EmbedUnity(onMessageFromUnity: _handleUnityMessage),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _sendDirectMessage,
                      child: const Text('Go to Result'),
                    ),
                    ElevatedButton(
                      onPressed: unityProvider.hideUnity,
                      child: const Text('Hide Unity'),
                    ),
                    ElevatedButton(
                      onPressed: _sendMessageToUnity,
                      child: const Text('Send Message to Unity'),
                    ),
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
