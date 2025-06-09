import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/account/account_local_data_source.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
import 'package:monkey_stories/data/models/account/update_user_info.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountRemoteDataSource accountRemoteDataSource;
  final SystemLocalDataSource systemLocalDataSource;
  final SettingsLocalDataSource settingsLocalDataSource;
  final AccountLocalDataSource accountLocalDataSource;
  AccountRepositoryImpl({
    required this.accountRemoteDataSource,
    required this.systemLocalDataSource,
    required this.settingsLocalDataSource,
    required this.accountLocalDataSource,
  });

  @override
  Future<Either<ServerFailureWithCode, LoadUpdateEntity?>> loadUpdate({
    bool showConnectionErrorDialog = true,
  }) async {
    final response = await accountRemoteDataSource.loadUpdate(
      showConnectionErrorDialog: showConnectionErrorDialog,
    );

    if (response.status == ApiStatus.success) {
      final countryCode = response.data?.location.countryCode;
      if (countryCode != null) {
        systemLocalDataSource.cacheCountryCode(countryCode);
        settingsLocalDataSource.saveLanguage(
          response.data?.syncUser.languageId ?? '',
        );
        settingsLocalDataSource.saveBackgroundMusic(
          response.data?.syncUser.soundtrack ?? true,
        );

        if (response.data?.syncUser.schedule != null) {
          settingsLocalDataSource.setSchedule(
            response.data!.syncUser.schedule!,
          );
        }
      }

      final userInfo = response.data?.toEntity();
      if (userInfo != null) {
        await accountLocalDataSource.cacheUserInfo(userInfo);
      }

      return Right(response.data?.toEntity());
    }

    return Left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }

  @override
  Future<Either<ServerFailureWithCode, Null>> updateUserInfo(
    UpdateUserInfoUsecaseParams params,
  ) async {
    final response = await accountRemoteDataSource.updateUserInfo(
      UpdateUserInfoParams(
        name: params.name,
        email: params.email,
        countryCode: params.countryCode,
        phone: params.phone,
        phoneString: params.phoneString,
      ),
    );
    if (response.status == ApiStatus.success) {
      return const Right(null);
    }

    return Left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}
