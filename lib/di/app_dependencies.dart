import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

// Import sl from the main container
import 'package:monkey_stories/di/injection_container.dart';

Future<void> initCoreAppDependencies() async {
  // Register SharedPreferences first as it's needed immediately
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Dio
  sl.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // App Level Bloc/Cubit
  // Depends on UseCases from Settings/System (registered in other_app_features) and UnityCubit (registered in unity_dependencies)
  // Ensure those are registered before AppCubit is potentially resolved.
  sl.registerLazySingleton(
    () => AppCubit(
      getLanguageUseCase: sl<GetLanguageUseCase>(),
      saveLanguageUseCase: sl<SaveLanguageUseCase>(),
      getThemeUseCase: sl<GetThemeUseCase>(),
      saveThemeUseCase: sl<SaveThemeUseCase>(),
      setPreferredOrientationsUseCase: sl<SetPreferredOrientationsUseCase>(),
      unityCubit:
          sl<UnityCubit>(), // Make sure UnityCubit is registered before this
    ),
  );
}
