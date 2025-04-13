import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/data/datasources/unity_datasource.dart';
import 'package:monkey_stories/data/repositories/unity_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';
import 'package:monkey_stories/domain/usecases/unity/handle_unity_message_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/register_handler_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_with_response_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/unregister_handler_usecase.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/auth_repository_impl.dart';
import 'package:monkey_stories/data/repositories/device_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';
import 'package:monkey_stories/domain/repositories/device_repository.dart';
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart';
import 'package:monkey_stories/presentation/bloc/splash/splash_cubit.dart';

import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/repositories/settings_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';

import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';
import 'package:monkey_stories/data/repositories/system_settings_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Khởi tạo tất cả các dependencies cho ứng dụng
Future<void> init() async {
  // External Dependencies (Core)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // App Level Bloc/Cubit
  sl.registerLazySingleton(
    () => AppCubit(
      getLanguageUseCase: sl(),
      saveLanguageUseCase: sl(),
      getThemeUseCase: sl(),
      saveThemeUseCase: sl(),
      setPreferredOrientationsUseCase: sl(),
      unityCubit: sl(),
    ),
  );

  // Khởi tạo dependencies cho Unity feature
  initUnityFeature();

  // Khởi tạo dependencies cho các tính năng App khác
  initAppFeatures();
}

/// Khởi tạo dependencies cho các tính năng App (Splash, Auth, Device, Settings, System)
void initAppFeatures() {
  // Presentation
  sl.registerFactory(
    () => SplashCubit(
      checkAuthStatusUseCase: sl(),
      registerDeviceUseCase: sl(),
      appCubit: sl(),
    ),
  );

  // Use Cases - Auth & Device & Settings & System
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl()));
  sl.registerLazySingleton(() => GetLanguageUseCase(sl()));
  sl.registerLazySingleton(() => SaveLanguageUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));
  sl.registerLazySingleton(() => SetPreferredOrientationsUseCase(sl()));

  // Repositories - Auth & Device & Settings & System
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SystemSettingsRepository>(
    () => SystemSettingsRepositoryImpl(dataSource: sl()),
  );

  // Data Sources - Auth & Device & Settings & System
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SystemSettingsDataSource>(
    () => SystemSettingsDataSourceImpl(),
  );
}

/// Khởi tạo dependencies cho tính năng Unity
void initUnityFeature() {
  // Presentation layer
  sl.registerLazySingleton(
    () => UnityCubit(
      sendMessageToUnityUseCase: sl(),
      sendMessageToUnityWithResponseUseCase: sl(),
      handleUnityMessageUseCase: sl(),
      registerHandlerUseCase: sl(),
      unregisterHandlerUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendMessageToUnityUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageToUnityWithResponseUseCase(sl()));
  sl.registerLazySingleton(() => HandleUnityMessageUseCase(sl()));
  sl.registerLazySingleton(() => RegisterHandlerUseCase(sl()));
  sl.registerLazySingleton(() => UnregisterHandlerUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UnityRepository>(
    () => UnityRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => UnityDataSource());
}
