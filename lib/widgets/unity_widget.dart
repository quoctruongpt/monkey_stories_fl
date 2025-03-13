import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:monkey_stories/providers/unity_provider.dart';
import '../screens/result_screen.dart';
import 'package:provider/provider.dart';

class UnityView extends StatefulWidget {
  const UnityView();

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> {
  late UnityProvider _unityProvider;

  @override
  void initState() {
    super.initState();
    _unityProvider = Provider.of<UnityProvider>(context, listen: false);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _unityProvider.showUnity();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UnityProvider>(
        builder: (context, unityProvider, child) {
          return Stack(
            children: [
              EmbedUnity(
                onMessageFromUnity: (String message) {
                  // Receive message from Unity sent via SendToFlutter.cs
                },
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultScreen(),
                          ),
                        );
                      },
                      child: const Text('Go to Result'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        unityProvider.hideUnity();
                      },
                      child: const Text('Hide Unity'),
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
