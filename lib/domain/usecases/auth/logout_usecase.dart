import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class LogoutUsecase extends UseCase<void, void> {
  final AuthRepository authRepository;

  LogoutUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(void params) async {
    return authRepository.logout();
  }
}
