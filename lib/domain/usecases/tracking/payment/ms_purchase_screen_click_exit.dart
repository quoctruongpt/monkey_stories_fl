import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user click vào nút "Thoát" trên màn hình mua gói
class MsPurchaseScreenClickExitTrackingUsecase
    extends UseCase<void, MsPurchaseScreenClickExitTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenClickExitTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenClickExitTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_click_exit',
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

class MsPurchaseScreenClickExitTrackingParams {
  final String source;
  final int timeOnScreen;

  MsPurchaseScreenClickExitTrackingParams({
    required this.source,
    required this.timeOnScreen,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
