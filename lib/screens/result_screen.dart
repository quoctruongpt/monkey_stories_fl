import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_stories/screens/home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Monkey Stories'),
              ),
            );
          },
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}

// SystemChrome.setPreferredOrientations([
//   DeviceOrientation.portraitUp,
// ]);
