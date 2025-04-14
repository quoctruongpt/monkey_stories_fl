import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/auth/user_sosial_entity.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class GetUserSocialUsecase implements UseCase<UserSocialEntity?, LoginType> {
  final AuthRepository authRepository;

  GetUserSocialUsecase(this.authRepository);

  @override
  Future<Either<Failure, UserSocialEntity?>> call(LoginType type) async =>
      authRepository.getUserSocial(type);
}
