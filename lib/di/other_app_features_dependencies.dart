import 'package:get_it/get_it.dart';
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';
import 'package:monkey_stories/data/repositories/device_repository_impl.dart';
import 'package:monkey_stories/data/repositories/settings_repository_impl.dart';
import 'package:monkey_stories/data/repositories/system_settings_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/device_repository.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';
import 'package:monkey_stories/presentation/bloc/splash/splash_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:monkey_stories/di/injection_container.dart';

void initOtherAppFeaturesDependencies() {
  // Presentation - SplashCubit depends on AppCubit and Auth usecases/repos
  // Ensure AppCubit (CoreApp) and Auth dependencies are registered first
  sl.registerLazySingleton(
    () => SplashCubit(
      checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
      registerDeviceUseCase: sl<RegisterDeviceUseCase>(),
      appCubit: sl<AppCubit>(),
    ),
  );

  // Use Cases - Auth & Device & Settings & System
  // These depend on their respective repositories
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => GetLanguageUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveLanguageUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => GetThemeUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(
    () => SetPreferredOrientationsUseCase(sl<SystemSettingsRepository>()),
  );

  // Repositories
  // Depend on their respective DataSources
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

  // Data Sources
  // Depend on external dependencies like SharedPreferences and Dio
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
}
