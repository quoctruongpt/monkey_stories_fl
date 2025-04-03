import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/blocs/debug/debug_cubit.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/navigation/app_routes.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/models/unity_message.dart';
import 'package:monkey_stories/models/unity_payload.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<UnityCubit>().registerHandler('user', (
      UnityMessage message,
    ) async {
      return {'id': 1234, 'name': 'John Smith', 'avatar': ''};
    });
  }

  @override
  void dispose() {
    context.read<UnityCubit>().unregisterHandler('user');
    super.dispose();
  }

  void _openUnity() {
    context.push(AppRoutes.unity);
  }

  void _openResult() {
    context.push(AppRoutes.result);
  }

  Future<void> _sendMessageToUnity() async {
    final message = UnityMessage<CoinPayload>(
      type: MessageTypes.coin,
      payload: CoinPayload(action: 'get'),
    );

    await context.read<UnityCubit>().sendMessageToUnityWithResponse(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context).translate('home.title')),
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
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AppCubit>().changeLanguage('vi');
                  },
                  child: const Text('vi'),
                );
              },
            ),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AppCubit>().changeLanguage('en');
                  },
                  child: const Text('en'),
                );
              },
            ),
            BlocBuilder<DebugCubit, DebugState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<DebugCubit>().toggleDebugView();
                  },
                  child: const Text('debug'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
