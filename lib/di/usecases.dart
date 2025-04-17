import 'package:get_it/get_it.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';
import 'package:monkey_stories/domain/usecases/auth/change_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/create_profile_usecase.dart';

// Auth & Account Usecases
import 'package:monkey_stories/domain/repositories/account_repository.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';
import 'package:monkey_stories/domain/usecases/account/get_load_update.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_last_login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_user_social_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_with_last_login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/logout_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_usecase.dart';

// Other App Features Usecases
import 'package:monkey_stories/domain/repositories/device_repository.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart'; // Used by Splash
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';

// Unity Usecases
import 'package:monkey_stories/domain/repositories/unity_repository.dart';
import 'package:monkey_stories/domain/usecases/unity/handle_unity_message_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/register_handler_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_with_response_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/unregister_handler_usecase.dart';

final sl = GetIt.instance;

void initUsecaseDependencies() {
  // Profile
  sl.registerLazySingleton(() => CreateProfileUsecase(sl<ProfileRepository>()));

  // Auth & Account
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => LoginWithLastLoginUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => GetLastLoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetUserSocialUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckPhoneNumberUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => CheckAuthStatusUseCase(sl<AuthRepository>()),
  ); // Used by Splash
  sl.registerLazySingleton(() => GetLoadUpdateUsecase(sl<AccountRepository>()));
  sl.registerLazySingleton(() => SendOtpUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl<AuthRepository>()));
  // Other App Features (Device, Settings, System)
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => GetLanguageUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveLanguageUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => GetThemeUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(
    () => SetPreferredOrientationsUseCase(sl<SystemSettingsRepository>()),
  );

  // Unity
  sl.registerLazySingleton(
    () => SendMessageToUnityUseCase(sl<UnityRepository>()),
  );
  sl.registerLazySingleton(
    () => SendMessageToUnityWithResponseUseCase(sl<UnityRepository>()),
  );
  sl.registerLazySingleton(
    () => HandleUnityMessageUseCase(sl<UnityRepository>()),
  );
  sl.registerLazySingleton(() => RegisterHandlerUseCase(sl<UnityRepository>()));
  sl.registerLazySingleton(
    () => UnregisterHandlerUseCase(sl<UnityRepository>()),
  );

  // Add other usecase registrations here...
}
