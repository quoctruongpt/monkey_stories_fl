import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class GetLastLoginUsecase implements UseCase<LastLoginEntity?, NoParams> {
  final AuthRepository authRepository;

  GetLastLoginUsecase(this.authRepository);

  @override
  Future<Either<Failure, LastLoginEntity?>> call(NoParams params) async =>
      authRepository.getLastLogin();
}
