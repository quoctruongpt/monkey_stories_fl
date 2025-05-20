import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monkey_stories/app.dart';
import 'package:monkey_stories/di/injection_container.dart' as di;
import 'package:monkey_stories/core/env/environment_service.dart';
import 'package:monkey_stories/core/extensions/logger_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:monkey_stories/core/utils/schedule.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monkey_stories/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  Logging.setupLogging();

  // Khởi tạo environment service
  await EnvironmentService().initialize();

  final storage = HydratedStorageDirectory(
    (await getTemporaryDirectory()).path,
  );
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: storage);

  // Khởi tạo dependency injection
  await di.init();

  // Khởi tạo notifications
  await initNotification(di.sl<FlutterLocalNotificationsPlugin>());

  // Đặt hướng màn hình mặc định ban đầu (ví dụ: portrait)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const MyApp());
}
