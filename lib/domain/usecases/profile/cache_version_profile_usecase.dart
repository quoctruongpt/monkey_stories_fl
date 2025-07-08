// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class CacheVersionProfileUsecase
    extends UseCase<void, CacheVersionProfileUsecaseParams> {
  final ProfileRepository _profileRepository;

  CacheVersionProfileUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, void>> call(
    CacheVersionProfileUsecaseParams params,
  ) async {
    return _profileRepository.saveVersionProfile(params.version);
  }
}

class CacheVersionProfileUsecaseParams {
  final int version;

  CacheVersionProfileUsecaseParams({required this.version});
}
