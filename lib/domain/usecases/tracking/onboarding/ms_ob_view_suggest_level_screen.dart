// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Khi user xem gợi ý level
class MsObViewSuggestLevelScreenTrackingUsecase
    extends UseCase<void, MsObViewSuggestLevelScreenParams> {
  final TrackingRepository trackingRepository;

  MsObViewSuggestLevelScreenTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(
    MsObViewSuggestLevelScreenParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_view_suggest_level_screen',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );

    return right(null);
  }
}

class MsObViewSuggestLevelScreenParams {
  final int timeOnScreen;
  final ClickType? clickType;

  MsObViewSuggestLevelScreenParams({
    required this.timeOnScreen,
    this.clickType,
  });

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType?.value};
  }

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }
}

enum ClickType {
  back('back'),
  continued('continue');

  final String value;

  const ClickType(this.value);
}
