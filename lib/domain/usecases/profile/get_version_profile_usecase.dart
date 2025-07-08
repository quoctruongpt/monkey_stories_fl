// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class GetVersionProfileUsecase
    extends UseCase<int?, GetVersionProfileUsecaseParams> {
  final ProfileRepository _profileRepository;

  GetVersionProfileUsecase(this._profileRepository);

  @override
  Future<Either<CacheFailure, int?>> call(
    GetVersionProfileUsecaseParams params,
  ) async {
    return _profileRepository.getVersionProfile();
  }
}

class GetVersionProfileUsecaseParams {
  GetVersionProfileUsecaseParams();
}
