import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/account/account_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountRemoteDataSource accountRemoteDataSource;

  AccountRepositoryImpl({required this.accountRemoteDataSource});

  @override
  Future<Either<ServerFailureWithCode, LoadUpdateEntity?>> loadUpdate() async {
    final response = await accountRemoteDataSource.loadUpdate();

    if (response.status == ApiStatus.success) {
      return Right(response.data?.toEntity());
    }

    return Left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}
