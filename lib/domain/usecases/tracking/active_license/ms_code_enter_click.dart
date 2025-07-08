// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// User click vào các nút trên màn hình
class MsCodeEnterClickTrackingUsecase
    extends UseCase<void, MsCodeEnterClickParams> {
  final TrackingRepository trackingRepository;

  MsCodeEnterClickTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsCodeEnterClickParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_code_enter_click',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsCodeEnterClickParams {
  final String source;
  final int timeOnScreen;
  final ClickType? clickType;

  MsCodeEnterClickParams({
    required this.source,
    required this.timeOnScreen,
    this.clickType,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.LABEL: source,
      AirbridgeAttribute.ACTION: clickType?.value,
    };
  }
}

enum ClickType {
  back('back'),
  qrScan('qr_scan'),
  next('next');

  const ClickType(this.value);

  final String value;
}
