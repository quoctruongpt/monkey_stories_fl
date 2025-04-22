import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:monkey_stories/data/datasources/course/course_remote_data.dart';
import 'package:monkey_stories/data/datasources/kinesis/kinesis_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_local_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Datasources
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';

// Other App Features Datasources
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';

// Unity Datasources
import 'package:monkey_stories/data/datasources/unity_datasource.dart';

final sl = GetIt.instance;

void initDatasourceDependencies() {
  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
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

  // Other App Features (Device, Settings, System)
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () =>
        SettingsLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SystemSettingsDataSource>(
    () => SystemSettingsDataSourceImpl(),
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

  // Add other datasource registrations here...
}
