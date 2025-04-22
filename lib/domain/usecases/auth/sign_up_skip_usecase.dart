import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class SignUpSkipUsecase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  SignUpSkipUsecase(this.repository);

  @override
  Future<Either<ServerFailureWithCode, bool>> call(NoParams params) async {
    return repository.signUp(null, null, null, LoginType.skip);
  }
}
