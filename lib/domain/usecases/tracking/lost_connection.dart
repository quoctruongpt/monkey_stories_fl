import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

class LostConnectionUsecase extends UseCase<void, LostConnectionParams> {
  final TrackingRepository trackingRepository;

  LostConnectionUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(LostConnectionParams params) async {
    trackingRepository.pushEvent(
      eventName: 'lost_connection',
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class LostConnectionParams {
  final String endPoint;

  LostConnectionParams({required this.endPoint});

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: endPoint};
  }
}
