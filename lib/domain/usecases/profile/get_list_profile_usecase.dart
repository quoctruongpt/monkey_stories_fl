import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class GetListProfileUsecase extends UseCase<List<ProfileEntity>, bool> {
  final ProfileRepository profileRepository;

  GetListProfileUsecase(this.profileRepository);

  @override
  Future<Either<ServerFailureWithCode, List<ProfileEntity>>> call(
    bool showConnectionErrorDialog,
  ) async {
    return profileRepository.getListProfile(
      showConnectionErrorDialog: showConnectionErrorDialog,
    );
  }
}
