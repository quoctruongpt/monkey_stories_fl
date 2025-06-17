import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user đăng ký thông tin trên màn hình mua gói
class MsPurchaseScreenRegisterTrackingUsecase
    extends UseCase<void, MsPurchaseScreenRegisterTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenRegisterTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenRegisterTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_register',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
    );
    return right(null);
  }
}

class MsPurchaseScreenRegisterTrackingParams {
  final String source;
  final int timeOnScreen;
  final String phone;
  final MsPurchaseScreenRegisterClickType clickType;
  final bool isSuccess;

  MsPurchaseScreenRegisterTrackingParams({
    required this.source,
    required this.timeOnScreen,
    required this.phone,
    required this.clickType,
    required this.isSuccess,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }

  Map<String, dynamic> toCustomProperties() {
    return {
      'time_on_screen': timeOnScreen,
      'phone_number': phone,
      'click_type': clickType.value,
      'is_success': isSuccess,
    };
  }
}

enum MsPurchaseScreenRegisterClickType {
  submit('submit'),
  close('close');

  final String value;

  const MsPurchaseScreenRegisterClickType(this.value);
}
