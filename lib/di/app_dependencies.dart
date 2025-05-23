import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:monkey_stories/core/network/dio_config.dart';

// Import sl from the main container
import 'package:monkey_stories/di/injection_container.dart';

Future<void> initCoreAppDependencies() async {
  // Register SharedPreferences first as it's needed immediately
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Dio
  sl.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // Register Kinesis
  sl.registerLazySingleton<Kinesis>(
    () => Kinesis(
      region: dotenv.env['KINESIS_REGION']!,
      credentials: AwsClientCredentials(
        accessKey: dotenv.env['KINESIS_ACCESS_KEY_ID']!,
        secretKey: dotenv.env['KINESIS_SECRET_ACCESS_KEY']!,
      ),
    ),
  );

  // Đăng ký singleton cho FlutterInappPurchase
  sl.registerLazySingleton<FlutterInappPurchase>(
    () => FlutterInappPurchase.instance,
  );

  // Đăng ký singleton cho FlutterLocalNotificationsPlugin
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // Đăng ký singleton cho FirebaseMessaging
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
}
