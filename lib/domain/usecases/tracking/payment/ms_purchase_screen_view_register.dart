import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi hiển thị màn hình để lại thông tin
class MsPurchaseScreenViewRegisterTrackingUsecase
    extends UseCase<void, MsPurchaseScreenViewRegisterTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsPurchaseScreenViewRegisterTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsPurchaseScreenViewRegisterTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_purchase_screen_view_register',
      semanticProperties: params.toSemanticProperties(),
    );
    return right(null);
  }
}

class MsPurchaseScreenViewRegisterTrackingParams {
  final String source;

  MsPurchaseScreenViewRegisterTrackingParams({required this.source});

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
