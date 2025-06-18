import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class SaveCurrentProfileUsecase extends UseCase<void, int> {
  final ProfileRepository _profileRepository;

  SaveCurrentProfileUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, void>> call(int params) async {
    return _profileRepository.saveCurrentProfile(params);
  }
}
