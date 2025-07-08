// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user click vào nút "Điều khoản và điều kiện" trên màn hình mua gói
class MsPurchaseScreenClickPolicyTrackingUsecase
    extends UseCase<void, MsPurchaseScreenClickPolicyTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenClickPolicyTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenClickPolicyTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_click_policy',
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

class MsPurchaseScreenClickPolicyTrackingParams {
  final String source;

  MsPurchaseScreenClickPolicyTrackingParams({required this.source});

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
