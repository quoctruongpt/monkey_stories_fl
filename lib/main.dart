import 'package:flutter/material.dart';
import 'package:monkey_stories/widgets/unity_widget.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/unity_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UnityProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkey Stories',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Stack(
        children: [
          const MyHomePage(title: 'Monkey Stories'),
          // const UnityView(),
          Consumer<UnityProvider>(
            builder: (context, unityProvider, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left:
                    unityProvider.isUnityVisible
                        ? 0
                        : -MediaQuery.of(context).size.width,
                top: 0,
                right:
                    unityProvider.isUnityVisible
                        ? 0
                        : MediaQuery.of(context).size.width,
                bottom: 0,
                child: const UnityView(),
              );
            },
          ),
        ],
      ),
    );
  }
}
