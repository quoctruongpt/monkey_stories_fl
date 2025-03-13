import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  void _openResult() {
    print('Opening Result...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
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
              onPressed: _openResult,
              child: const Text('Open Result'),
            ),
          ],
        ),
      ),
    );
  }
}
