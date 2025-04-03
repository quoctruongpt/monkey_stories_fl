import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/app.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/services/environment_service.dart';
import 'package:monkey_stories/services/logger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logging.setupLogging();

  // Khởi tạo environment service
  await EnvironmentService().initialize();

  runApp(BlocProvider(create: (context) => UnityCubit(), child: const MyApp()));
}
