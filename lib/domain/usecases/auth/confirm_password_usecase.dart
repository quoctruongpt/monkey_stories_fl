import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class ConfirmPasswordUsecase extends UseCase<void, ConfirmPasswordParams> {
  final AuthRepository repository;

  ConfirmPasswordUsecase({required this.repository});

  @override
  Future<Either<ServerFailureWithCode, void>> call(
    ConfirmPasswordParams params,
  ) async {
    return repository.confirmPassword(params.password, params.newPassword);
  }
}

class ConfirmPasswordParams {
  final String password;
  final String? newPassword;

  ConfirmPasswordParams({required this.password, this.newPassword});
}
