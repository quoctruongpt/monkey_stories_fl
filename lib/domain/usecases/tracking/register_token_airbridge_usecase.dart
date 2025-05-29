import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class RegisterTokenAirbridgeUsecase implements UseCase<void, NoParams> {
  final TrackingRepository _trackingRepository;

  RegisterTokenAirbridgeUsecase({
    required TrackingRepository trackingRepository,
  }) : _trackingRepository = trackingRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    _trackingRepository.registerToken();
    return const Right(null);
  }
}
