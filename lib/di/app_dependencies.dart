import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:monkey_stories/core/network/dio_config.dart';

// Import sl from the main container
import 'package:monkey_stories/di/injection_container.dart';

Future<void> initCoreAppDependencies() async {
  // Register SharedPreferences first as it's needed immediately
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Dio
  sl.registerLazySingleton<Dio>(() => DioConfig.createDio());
}
