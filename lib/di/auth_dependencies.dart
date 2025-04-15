import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_remote_data_source.dart';
import 'package:monkey_stories/data/repositories/account_repository_impl.dart';
import 'package:monkey_stories/data/repositories/auth_repository_impl.dart';
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
import 'package:monkey_stories/presentation/bloc/auth/login/login_cubit.dart';
import 'package:monkey_stories/presentation/bloc/auth/sign_up/sign_up_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Import sl from the main container
import 'package:monkey_stories/di/injection_container.dart';

void initAuthDependencies() {
  // Cubit - UserCubit needs to be singleton maybe? Let's make it lazy singleton for now.
  // Ensure it's registered before LoginCubit and SignUpCubit
  sl.registerLazySingleton(
    () => UserCubit(logoutUsecase: sl(), getLoadUpdateUsecase: sl()),
  );

  // UseCase
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LoginWithLastLoginUsecase(sl()));
  sl.registerLazySingleton(() => GetLastLoginUsecase(sl()));
  sl.registerLazySingleton(() => GetUserSocialUsecase(sl()));
  sl.registerLazySingleton(() => CheckPhoneNumberUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetLoadUpdateUsecase(sl()));
  // Cubit
  sl.registerFactory(
    () => LoginCubit(
      userCubit: sl<UserCubit>(),
      loginUsecase: sl<LoginUsecase>(),
      loginWithLastLoginUsecase: sl<LoginWithLastLoginUsecase>(),
      getLastLoginUsecase: sl<GetLastLoginUsecase>(),
      getUserSocialUsecase: sl<GetUserSocialUsecase>(),
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

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl<AuthLocalDataSource>(),
      remoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl<Dio>()),
  );

  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      accountRemoteDataSource: sl<AccountRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(dio: sl<Dio>()),
  );
}
