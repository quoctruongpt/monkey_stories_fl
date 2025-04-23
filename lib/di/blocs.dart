import 'package:get_it/get_it.dart';
import 'package:monkey_stories/domain/usecases/auth/change_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_skip_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/course/active_course_usecase.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/create_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_current_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_list_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/get_products_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/initial_purchased_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_level/choose_level_cubit.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_year_of_birth/choose_year_of_birth_cubit.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/create_profile_loading/create_profile_loading_cubit.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/input_name/input_name_cubit.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/bloc/float_button/float_button_cubit.dart';

// Auth & Account Usecases and Blocs/Cubits
import 'package:monkey_stories/domain/usecases/account/get_load_update.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_last_login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_user_social_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_with_last_login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/logout_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_usecase.dart';
import 'package:monkey_stories/presentation/bloc/auth/login/login_cubit.dart';
import 'package:monkey_stories/presentation/bloc/auth/sign_up/sign_up_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

// Other App Features Usecases and Blocs/Cubits
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/bloc/leave_contact/leave_contact_cubit.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/splash/splash_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart'; // AppCubit import

// Unity Usecases and Blocs/Cubits
import 'package:monkey_stories/domain/usecases/unity/handle_unity_message_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/register_handler_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_with_response_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/unregister_handler_usecase.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart'; // UnityCubit import

// Core App Usecases (needed by AppCubit)
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';

// Kinesis Usecases
import 'package:monkey_stories/domain/usecases/kinesis/put_setting_kinesis_usecase.dart';
import 'package:monkey_stories/presentation/bloc/verify_parent/verify_parent_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';

final sl = GetIt.instance;

void initBlocDependencies() {
  // General Blocs/Cubits
  sl.registerFactory(() => DebugCubit());
  sl.registerFactory(() => FloatButtonCubit());

  // Create Profile Blocs/Cubits
  sl.registerFactory(() => InputNameCubit());
  sl.registerFactory(() => ChooseYearOfBirthCubit());
  sl.registerFactory(() => ChooseLevelCubit());
  sl.registerFactory(
    () => CreateProfileLoadingCubit(profileCubit: sl<ProfileCubit>()),
  );

  // Auth & Account Blocs/Cubits
  sl.registerLazySingleton(
    () => UserCubit(
      logoutUsecase: sl<LogoutUsecase>(),
      getLoadUpdateUsecase: sl<GetLoadUpdateUsecase>(),
      profileCubit: sl<ProfileCubit>(),
    ),
  );
  sl.registerFactory(
    () => LoginCubit(
      userCubit: sl<UserCubit>(),
      loginUsecase: sl<LoginUsecase>(),
      loginWithLastLoginUsecase: sl<LoginWithLastLoginUsecase>(),
      getLastLoginUsecase: sl<GetLastLoginUsecase>(),
      getUserSocialUsecase: sl<GetUserSocialUsecase>(),
      profileCubit: sl<ProfileCubit>(),
    ),
  );
  sl.registerFactory(
    () => SignUpCubit(
      userCubit: sl<UserCubit>(),
      signUpUsecase: sl<SignUpUsecase>(),
      loginUsecase: sl<LoginUsecase>(),
      checkPhoneNumberUsecase: sl<CheckPhoneNumberUsecase>(),
    ),
  );

  // Other App Features Blocs/Cubits (Splash)
  sl.registerLazySingleton(
    () => SplashCubit(
      checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
      registerDeviceUseCase: sl<RegisterDeviceUseCase>(),
      appCubit: sl<AppCubit>(),
      userCubit: sl<UserCubit>(),
      profileCubit: sl<ProfileCubit>(),
      purchasedCubit: sl<PurchasedCubit>(),
    ),
  );

  // Unity Blocs/Cubits
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

  // App Level Blocs/Cubits (moved from app_dependencies)
  sl.registerLazySingleton(
    () => AppCubit(
      getLanguageUseCase: sl<GetLanguageUseCase>(),
      saveLanguageUseCase: sl<SaveLanguageUseCase>(),
      getThemeUseCase: sl<GetThemeUseCase>(),
      saveThemeUseCase: sl<SaveThemeUseCase>(),
      setPreferredOrientationsUseCase: sl<SetPreferredOrientationsUseCase>(),
      unityCubit: sl<UnityCubit>(), // UnityCubit is now also registered here
    ),
  );

  sl.registerFactory(
    () => ForgotPasswordCubit(
      verifyOtpUsecase: sl<VerifyOtpUsecase>(),
      sendOtpUsecase: sl<SendOtpUsecase>(),
      changePasswordUsecase: sl<ChangePasswordUsecase>(),
    ),
  );

  sl.registerFactory(
    () => OnboardingCubit(
      getLanguageUseCase: sl<GetLanguageUseCase>(),
      signUpSkipUsecase: sl<SignUpSkipUsecase>(),
      userCubit: sl<UserCubit>(),
      profileCubit: sl<ProfileCubit>(),
    ),
  );

  sl.registerFactory(
    () => LeaveContactCubit(saveContactUsecase: sl<SaveContactUsecase>()),
  );

  sl.registerLazySingleton(
    () => ProfileCubit(
      getListProfileUsecase: sl<GetListProfileUsecase>(),
      createProfileUsecase: sl<CreateProfileUsecase>(),
      getCurrentProfileUsecase: sl<GetCurrentProfileUsecase>(),
      activeCourseUsecase: sl<ActiveCourseUsecase>(),
      putSettingKinesisUsecase: sl<PutSettingKinesisUsecase>(),
    ),
  );

  sl.registerFactory(() => VerifyParentCubit());

  sl.registerLazySingleton(
    () => PurchasedCubit(
      initialPurchasedUsecase: sl<InitialPurchasedUsecase>(),
      getProductsUsecase: sl<GetProductsUsecase>(),
    ),
  );

  sl.registerFactory(
    () => PurchasedViewCubit(purchasedCubit: sl<PurchasedCubit>()),
  );

  // Add other Bloc/Cubit registrations here...
}
