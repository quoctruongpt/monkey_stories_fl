// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/remote_config_repository.dart';

class GetPassDebugUsecase extends UseCase<String, NoParams> {
  final RemoteConfigRepository _remoteConfigRepository;

  GetPassDebugUsecase(this._remoteConfigRepository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return _remoteConfigRepository.getPassDebug();
  }
}
