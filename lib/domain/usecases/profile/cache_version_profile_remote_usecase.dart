import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class CacheVersionProfileRemoteUsecase
    extends UseCase<void, CacheVersionProfileRemoteUsecaseParams> {
  final ProfileRepository _profileRepository;

  CacheVersionProfileRemoteUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, void>> call(
    CacheVersionProfileRemoteUsecaseParams params,
  ) async {
    return _profileRepository.saveVersionProfileRemote(params.version);
  }
}

class CacheVersionProfileRemoteUsecaseParams {
  final int version;

  CacheVersionProfileRemoteUsecaseParams({required this.version});
}
