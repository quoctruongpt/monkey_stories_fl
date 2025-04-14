import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/auth/login_with_last_login_entity.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class LoginWithLastLoginUsecase
    implements UseCase<bool, LoginWithLastLoginEntity> {
  final AuthRepository repository;

  LoginWithLastLoginUsecase(this.repository);

  @override
  Future<Either<ServerFailureWithCode, bool>> call(
    LoginWithLastLoginEntity params,
  ) async {
    return await repository.loginWithLastLogin(params);
  }
}
