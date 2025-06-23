import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user thanh toán thành công mà bị out giữa chừng -> quay lại app và view popup
class MsOrderCompleteCrashPopupTrackingUsecase
    extends UseCase<void, MsOrderCompleteCrashPopupTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsOrderCompleteCrashPopupTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsOrderCompleteCrashPopupTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_order_complete_crash_popup',
      semanticProperties: params.toSemanticProperties(),
      customProperties: params.toCustomProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

class MsOrderCompleteCrashPopupTrackingParams {
  final String source;
  final String choosePackage;

  MsOrderCompleteCrashPopupTrackingParams({
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
