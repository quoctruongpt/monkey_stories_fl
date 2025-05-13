import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
import 'package:monkey_stories/data/models/account/update_user_info.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountRemoteDataSource accountRemoteDataSource;
  final SystemLocalDataSource systemLocalDataSource;

  AccountRepositoryImpl({
    required this.accountRemoteDataSource,
    required this.systemLocalDataSource,
  });

  @override
  Future<Either<ServerFailureWithCode, LoadUpdateEntity?>> loadUpdate() async {
    final response = await accountRemoteDataSource.loadUpdate();

    if (response.status == ApiStatus.success) {
      final countryCode = response.data?.location.countryCode;
      if (countryCode != null) {
        systemLocalDataSource.cacheCountryCode(countryCode);
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
