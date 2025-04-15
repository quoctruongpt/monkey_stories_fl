import 'package:get_it/get_it.dart';
import 'package:monkey_stories/di/app_dependencies.dart';
import 'package:monkey_stories/di/auth_dependencies.dart';
import 'package:monkey_stories/di/other_app_features_dependencies.dart';
import 'package:monkey_stories/di/unity_dependencies.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/bloc/float_button/float_button_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Khởi tạo tất cả các dependencies cho ứng dụng
Future<void> init() async {
  // Core dependencies (SharedPreferences, Dio) & AppCubit
  // Note: UnityCubit is needed by AppCubit, so initUnity must come before initCoreApp
  initUnityDependencies(); // Moved Unity init first
  await initCoreAppDependencies();

  // Feature-specific dependencies
  initAuthDependencies();
  initOtherAppFeaturesDependencies(); // Initializes Splash, Device, Settings, System

  // Other independent Blocs/Cubits
  sl.registerFactory(() => DebugCubit());
  sl.registerFactory(() => FloatButtonCubit());

  // Ensure all async dependencies are ready if needed, especially SharedPreferences
  // await sl.isReady<SharedPreferences>(); // Optional: uncomment if facing issues with async dependencies
}
