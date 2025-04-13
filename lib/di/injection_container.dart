import 'package:get_it/get_it.dart';

import 'package:monkey_stories/data/datasources/unity_datasource.dart';
import 'package:monkey_stories/data/repositories/unity_repository_impl.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';
import 'package:monkey_stories/domain/usecases/unity/handle_unity_message_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/register_handler_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_with_response_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/unregister_handler_usecase.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Khởi tạo tất cả các dependencies cho ứng dụng
Future<void> init() async {
  // Khởi tạo dependencies cho Unity feature
  await initUnityFeature();

  // Trong tương lai có thể thêm các features khác
  // await initAnotherFeature();
}

/// Khởi tạo dependencies cho tính năng Unity
Future<void> initUnityFeature() async {
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
