import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:monkey_stories/data/datasources/active_license/active_license_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/course/course_remote_data.dart';
import 'package:monkey_stories/data/datasources/download/download_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/kinesis/kinesis_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_local_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/notification/notification_remote_data_soure.dart';
import 'package:monkey_stories/data/datasources/report/report_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/purchased/purchased_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/airbridge/airbridge_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/tracking/tracking_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Datasources
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/account/account_local_data_source.dart';

// Other App Features Datasources
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
// Unity Datasources
import 'package:monkey_stories/data/datasources/unity_datasource.dart';
import 'package:monkey_stories/data/datasources/offline/offline_local_data_source.dart';
import 'package:monkey_stories/data/datasources/offline/offline_local_data_source_impl.dart';

final sl = GetIt.instance;

void initDatasourceDependencies() {
  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      dio: sl<Dio>(),
      downloadRemoteDataSource: sl<DownloadRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<DownloadRemoteDataSource>(
    () => DownloadRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AccountLocalDataSource>(
    () => AccountLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  // Other App Features (Device, Settings, System)
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      flutterLocalNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
    ),
  );
  sl.registerLazySingleton<SystemSettingsDataSource>(
    () => SystemSettingsDataSourceImpl(),
  );
  sl.registerLazySingleton<SystemLocalDataSource>(
    () => SystemLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Unity
  sl.registerLazySingleton(() => UnityDataSource());

  // Leave Contact
  sl.registerLazySingleton<LeaveContactRemoteDataSource>(
    () => LeaveContactRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<LeaveContactLocalDataSource>(
    () => LeaveContactLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Profile
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () =>
        ProfileLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Course
  sl.registerLazySingleton<CourseRemoteData>(
    () => CourseRemoteDataImpl(dio: sl<Dio>()),
  );

  // Kinesis
  sl.registerLazySingleton<KinesisRemoteDataSource>(
    () => KinesisRemoteDataSourceImpl(kinesisClient: sl<Kinesis>()),
  );

  // Purchased
  sl.registerLazySingleton<PurchasedRemoteDataSource>(
    () => PurchasedRemoteDataSourceImpl(
      flutterInappPurchase: sl<FlutterInappPurchase>(),
      systemLocalDataSource: sl<SystemLocalDataSource>(),
      dio: sl<Dio>(),
    ),
  );

  // Active license
  sl.registerLazySingleton<ActiveLicenseRemoteDataSource>(
    () => ActiveLicenseRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Settings
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Notification
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      firebaseMessaging: sl<FirebaseMessaging>(),
      dio: sl<Dio>(),
    ),
  );

  // Tracking
  sl.registerLazySingleton<AirbridgeRemoteDataSource>(
    () => AirbridgeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TrackingLocalDataSource>(
    () => TrackingLocalDataSourceImpl(
      profileLocalDataSource: sl<ProfileLocalDataSource>(),
      accountLocalDataSource: sl<AccountLocalDataSource>(),
    ),
  );

  // Report
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Offline
  sl.registerLazySingleton<OfflineLocalDataSource>(
    () =>
        OfflineLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Add other datasource registrations here...
}
