import 'package:get_it/get_it.dart';

import 'package:monkey_stories/di/app_dependencies.dart';

// Add imports for the new layer-based dependency files
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/di/repositories.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/data/datasources/tracking/tracking_local_data_source.dart';

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

  // Start listening for attribution data
  sl<TrackingLocalDataSource>().listenToAttributionAndCache();
}
