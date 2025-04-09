import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart';
import 'package:monkey_stories/blocs/debug/debug_cubit.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/navigation/app_routes.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/models/unity_message.dart';
import 'package:monkey_stories/models/unity_payload.dart';
import 'package:monkey_stories/widgets/button_widget.dart';

final logger = Logger('HomeScreen');

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final UnityCubit _unityCubit;

  @override
  void initState() {
    super.initState();
    _unityCubit = context.read<UnityCubit>();
    _unityCubit.registerHandler('user', (UnityMessage message) async {
      return {'id': 1234, 'name': 'John Smith', 'avatar': ''};
    });
  }

  @override
  void dispose() {
    _unityCubit.unregisterHandler('user');
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

    try {
      final response = await _unityCubit.sendMessageToUnityWithResponse(
        message,
      );
      logger.info('Nhận phản hồi từ Unity: $response');
    } catch (error) {
      logger.severe('Lỗi khi giao tiếp với Unity: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể kết nối với Unity: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    context.read<DebugCubit>().toggleModeDebug();
                  },
                  child: const Text('debug'),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationCubit>().logOut();
                context.go(AppRoutes.login);
              },
              child: const Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
