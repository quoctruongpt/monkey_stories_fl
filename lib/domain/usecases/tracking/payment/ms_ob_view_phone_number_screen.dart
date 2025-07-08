// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/ms_purchase_screen_register.dart';

// Ghi nhận khi user vào màn hình nhập số điện thoại
class MsObViewPhoneNumberScreenTrackingUsecase
    extends UseCase<void, MsObViewPhoneNumberScreenTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsObViewPhoneNumberScreenTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsObViewPhoneNumberScreenTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_ob_view_phone_number_screen',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
    );
    return right(null);
  }
}

class MsObViewPhoneNumberScreenTrackingParams {
  final int timeOnScreen;
  final bool isSuccess;
  final String? errorMessage;
  final String? phoneNumber;
  final MsPurchaseScreenRegisterClickType? clickType;

  MsObViewPhoneNumberScreenTrackingParams({
    required this.timeOnScreen,
    required this.isSuccess,
    this.errorMessage,
    this.clickType,
    this.phoneNumber,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType?.value};
  }

  Map<String, dynamic> toCustomProperties() {
    return {
      'time_on_screen': timeOnScreen,
      'is_success': isSuccess,
      'error_message': errorMessage,
      'phone_number': phoneNumber,
    };
  }
}
