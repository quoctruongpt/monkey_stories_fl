import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:monkey_stories/providers/unity_provider.dart';
import 'package:provider/provider.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openUnity() {
    print('Opening Unity...');
    Provider.of<UnityProvider>(context, listen: false).showUnity();
  }

  void _openResult() {
    print('Opening Result...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
  }

  void _sendMessageToUnity() {
    print('Sending message to Unity...');
    // final unityProvider = Provider.of<UnityProvider>(context, listen: false);
    // unityProvider.showUnity();
    // Add a delay to ensure Unity is loaded before sending message
    Future.delayed(const Duration(milliseconds: 500), () {
      sendToUnity(
        'GameManager',
        'ReceiveMessageFromFlutter',
        'Hello from Flutter!',
      );
    });
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
