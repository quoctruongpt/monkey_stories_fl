import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class PutEventToAirbridgeUsecase
    extends UseCase<void, PutEventToAirbridgeParams> {
  final TrackingRepository trackingRepository;

  PutEventToAirbridgeUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(PutEventToAirbridgeParams params) async {
    trackingRepository.pushEvent(
      eventName: params.eventName,
      semanticProperties: params.semanticProperties,
      customProperties: params.customProperties,
      isPushAirbridge: true,
      isPushKinesis: false,
    );
    return const Right(null);
  }
}

class PutEventToAirbridgeParams {
  final String eventName;
  final Map<String, dynamic> semanticProperties;
  final Map<String, dynamic> customProperties;

  PutEventToAirbridgeParams({
    required this.eventName,
    required this.semanticProperties,
    required this.customProperties,
  });
}
