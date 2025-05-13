import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class ConfirmPasswordUsecase extends UseCase<void, String> {
  final AuthRepository repository;

  ConfirmPasswordUsecase({required this.repository});

  @override
  Future<Either<ServerFailureWithCode, void>> call(String password) async {
    return repository.confirmPassword(password);
  }
}
