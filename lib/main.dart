import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monkey_stories/app.dart';
import 'package:monkey_stories/di/injection_container.dart' as di;
import 'package:monkey_stories/services/environment_service.dart';
import 'package:monkey_stories/services/logger_service.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logging.setupLogging();

  // Khởi tạo environment service
  await EnvironmentService().initialize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  // Khởi tạo dependency injection
  await di.init();

  runApp(const MyApp());
}
