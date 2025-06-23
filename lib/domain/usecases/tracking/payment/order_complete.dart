import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_name.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user thanh toán thành công
class OrderCompleteTrackingUsecase
    extends UseCase<void, OrderCompleteTrackingParams> {
  final TrackingRepository _trackingRepository;

  OrderCompleteTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(OrderCompleteTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: AirbridgeName.ORDER_COMPLETED,
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );

    return right(null);
  }
}

class OrderCompleteTrackingParams {
  final String source;
  final String choosePackage;
  final double totalPrice;
  final ClickType clickType;

  OrderCompleteTrackingParams({
    required this.source,
    required this.choosePackage,
    required this.totalPrice,
    required this.clickType,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.LABEL: source,
      AirbridgeAttribute.VALUE: totalPrice,
    };
  }

  Map<String, dynamic> toCustomProperties() {
    return {'choose_package': choosePackage, 'click_type': clickType.value};
  }
}

enum ClickType {
  learnNow('learn_now'),
  register('register'),
  killApp('kill_app');

  const ClickType(this.value);

  final String value;
}
