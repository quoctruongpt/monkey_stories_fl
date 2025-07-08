// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi user view màn hình nhập mã kích hoạt
class MsCodeEnterViewTrackingUsecase
    extends UseCase<void, MsCodeEnterViewParams> {
  final TrackingRepository trackingRepository;

  MsCodeEnterViewTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsCodeEnterViewParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_code_enter_view',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsCodeEnterViewParams {
  final String source;
  final int timeOnScreen;

  MsCodeEnterViewParams({required this.source, required this.timeOnScreen});

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
