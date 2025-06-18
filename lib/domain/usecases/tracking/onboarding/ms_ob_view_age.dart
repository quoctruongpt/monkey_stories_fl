import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Khi user xem màn hình chọn tuổi
class MsObViewAgeTrackingUsecase extends UseCase<void, MsObViewAgeParams> {
  final TrackingRepository trackingRepository;

  MsObViewAgeTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(MsObViewAgeParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_view_age',
      semanticProperties: params.toSemanticProperties(),
    );

    return right(null);
  }
}

class MsObViewAgeParams {
  final String source;

  MsObViewAgeParams({required this.source});

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
