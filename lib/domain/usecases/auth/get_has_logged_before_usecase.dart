import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class GetHasLoggedBeforeUsecase extends UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  GetHasLoggedBeforeUsecase(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return authRepository.getHasLoggedBefore();
  }
}
