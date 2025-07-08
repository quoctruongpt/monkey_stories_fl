// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user click vào nút "Thanh toán" nhưng thanh toán thất bại
class OrderFailTrackingUsecase extends UseCase<void, OrderFailTrackingParams> {
  final TrackingRepository _trackingRepository;

  OrderFailTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(OrderFailTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'order_fail',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
    );

    return right(null);
  }
}

class OrderFailTrackingParams {
  final String source;
  final String choosePackage;
  final String errorMessage;
  final double totalPrice;

  OrderFailTrackingParams({
    required this.source,
    required this.choosePackage,
    required this.errorMessage,
    required this.totalPrice,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.LABEL: source,
      AirbridgeAttribute.VALUE: totalPrice,
    };
  }

  Map<String, dynamic> toCustomProperties() {
    return {'choose_package': choosePackage, 'error_message': errorMessage};
  }
}
