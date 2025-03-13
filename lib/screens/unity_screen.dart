import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'result_screen.dart';

class UnityView extends StatefulWidget {
  const UnityView();

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: EmbedUnity(
              onMessageFromUnity: (String message) {
                // Receive message from Unity sent via SendToFlutter.cs
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResultScreen()),
                );
              },
              child: const Text('Go to Result'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Hide Unity'),
            ),
          ),
        ],
      ),
    );
  }
}
