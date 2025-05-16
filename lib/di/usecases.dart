import 'package:get_it/get_it.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';
import 'package:monkey_stories/domain/repositories/course_repository.dart';
import 'package:monkey_stories/domain/repositories/leave_contact_repository.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_license_code.dart';
import 'package:monkey_stories/domain/usecases/auth/change_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/confirm_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_skip_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_has_logged_before_usecase.dart';
import 'package:monkey_stories/domain/usecases/course/active_course_usecase.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';
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
import 'package:monkey_stories/domain/usecases/profile/get_current_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_list_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/get_products_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/listen_to_purchse_updated_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/restore_purchased_usecase.dart';
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

// Kinesis Usecases
import 'package:monkey_stories/domain/repositories/kinesis_repository.dart';
import 'package:monkey_stories/domain/usecases/kinesis/put_setting_kinesis_usecase.dart';

// Purchased Usecases
import 'package:monkey_stories/domain/usecases/purchased/initial_purchased_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/puchase_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/listen_to_purchase_error_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/dispose_purchse_error_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/verify_purchased_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/complete_purchase_usecase.dart';
import 'package:monkey_stories/domain/usecases/active_license/link_cod_to_this_account.dart';
import 'package:monkey_stories/domain/usecases/active_license/link_cod_to_account.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_cod_usercrm.dart';
import 'package:monkey_stories/domain/usecases/profile/update_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_sound_track_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_sound_track_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_schedule_usecase.dart';

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
  sl.registerLazySingleton(
    () => UpdateUserInfoUsecase(accountRepository: sl<AccountRepository>()),
  );
  sl.registerLazySingleton(
    () => ConfirmPasswordUsecase(repository: sl<AuthRepository>()),
  );

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

  // Leave Contact
  sl.registerLazySingleton(
    () => SaveContactUsecase(sl<LeaveContactRepository>()),
  );

  // Onboarding
  sl.registerLazySingleton(() => SignUpSkipUsecase(sl<AuthRepository>()));

  // Profile
  sl.registerLazySingleton(
    () => GetListProfileUsecase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCurrentProfileUsecase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl<ProfileRepository>()));

  // Course
  sl.registerLazySingleton(() => ActiveCourseUsecase(sl<CourseRepository>()));

  // Kinesis
  sl.registerLazySingleton(
    () => PutSettingKinesisUsecase(sl<KinesisRepository>()),
  );

  // Purchased
  sl.registerLazySingleton(() => GetProductsUsecase(sl<PurchasedRepository>()));
  sl.registerLazySingleton(
    () => InitialPurchasedUsecase(sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(() => PurchaseUsecase(sl<PurchasedRepository>()));
  sl.registerLazySingleton(
    () => ListenToPurchaseErrorsUseCase(sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(
    () => DisposePurchasedUseCase(sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(
    () => ListenToPurchaseUpdatesUseCase(sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(
    () => VerifyPurchasedUsecase(sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(
    () => RestorePurchasedUsecase(sl<PurchasedRepository>()),
  );

  // Active license
  sl.registerLazySingleton(
    () => VerifyLicenseCodeUseCase(sl<ActiveLicenseRepository>()),
  );
  sl.registerLazySingleton(
    () => LinkCodToThisAccountUseCase(sl<ActiveLicenseRepository>()),
  );
  sl.registerLazySingleton(
    () => LinkCodToAccountUseCase(
      sl<ActiveLicenseRepository>(),
      sl<AuthRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => VerifyCodUserCrmUseCase(sl<ActiveLicenseRepository>()),
  );
  sl.registerLazySingleton(
    () => GetHasLoggedBeforeUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => CompletePurchaseUsecase(repository: sl<PurchasedRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveSoundTrackUsecase(repository: sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSoundTrackUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveScheduleUsecase(settingsRepository: sl<SettingsRepository>()),
  );
  // Add other usecase registrations here...
}
