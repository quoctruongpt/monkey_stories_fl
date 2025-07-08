// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Bắn lên khi thoát khỏi màn chọn ngôn ngữ
class MsObSelectLanguageTrackingUsecase
    extends UseCase<void, MsObSelectLanguageParams> {
  final TrackingRepository trackingRepository;

  MsObSelectLanguageTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(MsObSelectLanguageParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_select_language',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );

    return right(null);
  }
}

class MsObSelectLanguageParams {
  final String language;
  final int timeOnScreen;

  MsObSelectLanguageParams({
    required this.language,
    required this.timeOnScreen,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.VALUE: language};
  }
}
