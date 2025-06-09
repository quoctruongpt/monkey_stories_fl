import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/offline_repository.dart';

class CheckOfflineStatusUseCase implements UseCase<bool, NoParams> {
  final OfflineRepository repository;

  CheckOfflineStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isOfflinePeriodExpired();
  }
}
