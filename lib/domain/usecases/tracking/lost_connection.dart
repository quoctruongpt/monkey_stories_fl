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
      customProperties: params.toCustomProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return const Right(null);
  }
}

class LostConnectionParams {
  final String endPoint;
  final String? errorMessage;
  final String? screenName;

  LostConnectionParams({
    required this.endPoint,
    this.errorMessage,
    this.screenName,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: endPoint};
  }

  Map<String, dynamic> toCustomProperties() {
    return {'error_message': errorMessage, 'screen_name': screenName};
  }
}
