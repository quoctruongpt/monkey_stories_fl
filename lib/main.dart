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
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Xử lý thông báo khi ứng dụng ở foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;

    if (notification != null && (android != null || apple != null)) {
      di.sl<FlutterLocalNotificationsPlugin>().show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'monkey_stories', // Thay thế bằng ID channel của bạn
            'monkey_stories', // Thay thế bằng tên channel của bạn
            channelDescription:
                'monkey_stories', // Thay thế bằng mô tả channel của bạn
            icon:
                'ic_launcher', // Thay thế bằng icon của bạn (ví dụ: @mipmap/ic_launcher)
            priority: Priority.high,
            importance: Importance.max,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  });

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
