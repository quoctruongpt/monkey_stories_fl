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

// Import sl from the main container
import 'package:monkey_stories/di/injection_container.dart';

void initUnityDependencies() {
  // Presentation layer - UnityCubit
  // Needs to be registered before AppCubit in app_dependencies.dart
  sl.registerLazySingleton(
    () => UnityCubit(
      sendMessageToUnityUseCase: sl<SendMessageToUnityUseCase>(),
      sendMessageToUnityWithResponseUseCase:
          sl<SendMessageToUnityWithResponseUseCase>(),
      handleUnityMessageUseCase: sl<HandleUnityMessageUseCase>(),
      registerHandlerUseCase: sl<RegisterHandlerUseCase>(),
      unregisterHandlerUseCase: sl<UnregisterHandlerUseCase>(),
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
    () => UnityRepositoryImpl(dataSource: sl<UnityDataSource>()),
  );

  // Data sources
  sl.registerLazySingleton(() => UnityDataSource());
}
