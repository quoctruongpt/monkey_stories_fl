import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user vào màn hình mua gói
class MsPurchaseScreenViewTrackingUsecase
    extends UseCase<void, MsPurchaseScreenViewTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenViewTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenViewTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_view',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

class MsPurchaseScreenViewTrackingParams {
  final String source;
  final String tagName01;

  MsPurchaseScreenViewTrackingParams({
    required this.source,
    required this.tagName01,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }

  Map<String, dynamic> toCustomProperties() {
    return {'tag_name_01': tagName01};
  }
}
