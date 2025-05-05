import 'package:get_it/get_it.dart';
// Removed profile, debug, float_button imports
// import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
// import 'package:monkey_stories/data/repositories/profile_repository_impl.dart';
import 'package:monkey_stories/di/app_dependencies.dart';
// Removed feature-specific dependency imports
// import 'package:monkey_stories/di/auth_dependencies.dart';
// import 'package:monkey_stories/di/other_app_features_dependencies.dart';
// import 'package:monkey_stories/di/unity_dependencies.dart';
// import 'package:monkey_stories/domain/repositories/profile_repository.dart';
// import 'package:monkey_stories/domain/usecases/profile/create_profile_usecase.dart';
// import 'package:monkey_stories/presentation/bloc/create_profile/choose_level/choose_level_cubit.dart';
// import 'package:monkey_stories/presentation/bloc/create_profile/choose_year_of_birth/choose_year_of_birth_cubit.dart';
// import 'package:monkey_stories/presentation/bloc/create_profile/create_profile_loading/create_profile_loading_cubit.dart';
// import 'package:monkey_stories/presentation/bloc/create_profile/input_name/input_name_cubit.dart';
// import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
// import 'package:monkey_stories/presentation/bloc/float_button/float_button_cubit.dart';
// import 'package:dio/dio.dart'; // Dio might still be needed by core/feature dependencies

// Add imports for the new layer-based dependency files
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/di/repositories.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/di/blocs.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Khởi tạo tất cả các dependencies cho ứng dụng
Future<void> init() async {
  // Core dependencies (SharedPreferences, Dio)
  await initCoreAppDependencies(); // Initializes SharedPreferences, Dio

  // Layer-specific dependencies (Call in order)
  initDatasourceDependencies();
  initRepositoryDependencies();
  initUsecaseDependencies();
  initBlocDependencies(); // Initializes all Blocs/Cubits including AppCubit & UnityCubit
}
