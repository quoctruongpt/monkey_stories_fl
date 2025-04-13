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

/// Service locator instance
final sl = GetIt.instance;

/// Khởi tạo tất cả các dependencies cho ứng dụng
Future<void> init() async {
  // External Dependencies (Core)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // App Level Bloc/Cubit
  initAppFeatures();

  // Khởi tạo dependencies cho Unity feature
  initUnityFeature();

  // Khởi tạo dependencies cho Splash/Auth/Device/Settings
  initSplashFeatures();

  // Trong tương lai có thể thêm các features khác
  // await initAnotherFeature();
}

void initAppFeatures() {
  // Presentation
  sl.registerLazySingleton(
    () => AppCubit(
      getLanguageUseCase: sl(),
      saveLanguageUseCase: sl(),
      getThemeUseCase: sl(),
      saveThemeUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetLanguageUseCase(sl()));
  sl.registerLazySingleton(() => SaveLanguageUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));
}

/// Khởi tạo dependencies cho tính năng Splash/Auth/Device/Settings
void initSplashFeatures() {
  // Presentation
  sl.registerFactory(
    () => SplashCubit(
      checkAuthStatusUseCase: sl(),
      registerDeviceUseCase: sl(),
      appCubit: sl(),
    ),
  );

  // Use Cases - Auth & Device
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl()));

  // Repositories - Auth & Device
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Repository - Settings
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources - Auth & Device
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(dioClient: sl()),
  );

  // Data Source - Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
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
