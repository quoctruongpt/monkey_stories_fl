import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_stories/constants/unity.dart';
import 'package:monkey_stories/providers/unity_provider.dart';
import 'package:provider/provider.dart';
import 'result_screen.dart';
import 'package:monkey_stories/types/unity.dart';
import 'package:monkey_stories/services/unity_service.dart';

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
    Provider.of<UnityProvider>(context, listen: false).registerHandler('user', (
      UnityMessage message,
    ) async {
      // Process the user message and return a response
      return {"id": 1234, "name": 'John Smith', "avatar": ''};
    });
  }

  @override
  void dispose() {
    Provider.of<UnityProvider>(
      context,
      listen: false,
    ).unregisterHandler('user');
    super.dispose();
  }

  void _openUnity() {
    final message = UnityMessage(
      type: MessageTypes.openUnity,
      payload: {'destination': 'map_lesson'},
    );
    UnityService.sendToUnityWithoutResult(message);
    Provider.of<UnityProvider>(context, listen: false).showUnity();
  }

  void _openResult() {
    print('Opening Result...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
  }

  Future<void> _sendMessageToUnity() async {
    print("vao day");
    final message = UnityMessage(
      type: MessageTypes.coin,
      payload: {'action': 'get'},
    );

    final response = await Provider.of<UnityProvider>(
      context,
      listen: false,
    ).sendMessageToUnityWithResponse(message);

    print(response.toString());
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
