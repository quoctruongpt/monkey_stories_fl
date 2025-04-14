import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';

abstract class AccountRepository {
  Future<Either<ServerFailureWithCode, LoadUpdateEntity?>> loadUpdate();
}
