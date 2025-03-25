import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/services/unity_service.dart';
import 'package:monkey_stories/types/unity.dart';

import 'result_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    context.read<UnityCubit>().registerHandler('user', (
      UnityMessage message,
    ) async {
      return {"id": 1234, "name": 'John Smith', "avatar": ''};
    });
  }

  @override
  void dispose() {
    context.read<UnityCubit>().unregisterHandler('user');
    super.dispose();
  }

  void _openUnity() {
    final message = UnityMessage(
      type: MessageTypes.openUnity,
      payload: {'destination': 'map_lesson'},
    );
    UnityService.sendToUnityWithoutResult(message);
    context.read<UnityCubit>().showUnity();
  }

  void _openResult() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
  }

  Future<void> _sendMessageToUnity() async {
    final message = UnityMessage(
      type: MessageTypes.coin,
      payload: {'action': 'get'},
    );

    final response = await context
        .read<UnityCubit>()
        .sendMessageToUnityWithResponse(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Monkey Stories!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openUnity,
              child: const Text('Open Unity'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessageToUnity,
              child: const Text('Send Message to Unity'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openResult,
              child: const Text('Open Result'),
            ),
          ],
        ),
      ),
    );
  }
}
