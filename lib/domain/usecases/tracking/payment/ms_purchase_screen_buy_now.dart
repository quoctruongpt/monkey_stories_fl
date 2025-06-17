import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user click vào nút "Mua ngay" trên màn hình mua gói
class MsPurchaseScreenBuyNowTrackingUsecase
    extends UseCase<void, MsPurchaseScreenBuyNowTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenBuyNowTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenBuyNowTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_buy_now',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
    );

    return right(null);
  }
}

class MsPurchaseScreenBuyNowTrackingParams {
  final String source;
  final String choosePackage;

  MsPurchaseScreenBuyNowTrackingParams({
    required this.source,
    required this.choosePackage,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }

  Map<String, dynamic> toCustomProperties() {
    return {'choose_package': choosePackage};
  }
}
