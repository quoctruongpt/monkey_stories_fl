import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monkey_stories/app.dart';
import 'package:monkey_stories/di/injection_container.dart' as di;
import 'package:monkey_stories/core/env/environment_service.dart';
import 'package:monkey_stories/core/extensions/logger_service.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logging.setupLogging();

  // Khởi tạo environment service
  await EnvironmentService().initialize();

  final storage = HydratedStorageDirectory(
    (await getTemporaryDirectory()).path,
  );
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: storage);

  // Khởi tạo dependency injection
  await di.init();

  // Đặt hướng màn hình mặc định ban đầu (ví dụ: portrait)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}
