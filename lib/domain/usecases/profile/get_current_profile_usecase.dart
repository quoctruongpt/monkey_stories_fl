import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class GetCurrentProfileUsecase extends UseCase<int, NoParams> {
  final ProfileRepository _profileRepository;

  GetCurrentProfileUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, int>> call(NoParams params) async {
    return _profileRepository.getCurrentProfile();
  }
}
