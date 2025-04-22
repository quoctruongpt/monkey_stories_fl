import 'package:get_it/get_it.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_local_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/leave_contact_repository_impl.dart';
import 'package:monkey_stories/data/repositories/profile_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/leave_contact_repository.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

// Auth Datasources & Repositories
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/auth_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/account_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';

// Other App Features Datasources & Repositories
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/device_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/device_repository.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/repositories/settings_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';
import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';
import 'package:monkey_stories/data/repositories/system_settings_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';

// Unity Datasources & Repositories
import 'package:monkey_stories/data/datasources/unity_datasource.dart';
import 'package:monkey_stories/data/repositories/unity_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';

final sl = GetIt.instance;

void initRepositoryDependencies() {
  // Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileRemoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  // Auth & Account
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl<AuthLocalDataSource>(),
      remoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      accountRemoteDataSource: sl<AccountRemoteDataSource>(),
    ),
  );

  // Other App Features (Device, Settings, System)
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDataSource: sl<DeviceRemoteDataSource>(),
      localDataSource: sl<DeviceLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () =>
        SettingsRepositoryImpl(localDataSource: sl<SettingsLocalDataSource>()),
  );
  sl.registerLazySingleton<SystemSettingsRepository>(
    () => SystemSettingsRepositoryImpl(
      dataSource: sl<SystemSettingsDataSource>(),
    ),
  );

  // Unity
  sl.registerLazySingleton<UnityRepository>(
    () => UnityRepositoryImpl(dataSource: sl<UnityDataSource>()),
  );

  // Leave Contact
  sl.registerLazySingleton<LeaveContactRepository>(
    () => LeaveContactRepositoryImpl(
      remoteDataSource: sl<LeaveContactRemoteDataSource>(),
      localDataSource: sl<LeaveContactLocalDataSource>(),
    ),
  );

  // Add other repository registrations here...
}
