// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class GetVersionProfileRemoteUsecase
    extends UseCase<int?, GetVersionProfileRemoteUsecaseParams> {
  final ProfileRepository _profileRepository;

  GetVersionProfileRemoteUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, int?>> call(
    GetVersionProfileRemoteUsecaseParams params,
  ) async {
    return _profileRepository.getVersionProfileRemote();
  }
}

class GetVersionProfileRemoteUsecaseParams {
  GetVersionProfileRemoteUsecaseParams();
}
