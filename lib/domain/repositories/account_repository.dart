import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';

abstract class AccountRepository {
  Future<Either<ServerFailureWithCode, LoadUpdateEntity?>> loadUpdate();
  Future<Either<ServerFailureWithCode, Null>> updateUserInfo(
    UpdateUserInfoUsecaseParams params,
  );
}
