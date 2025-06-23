import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsSelectLevelTrackingUsecase
    extends UseCase<void, MsSelectLevelTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsSelectLevelTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsSelectLevelTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_select_level',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: false,
    );
    return right(null);
  }
}

enum MsSelectLevelType {
  entry('entry'),
  basic('basic'),
  intermediate('intermediate'),
  advanced('advanced'),
  none('null');

  final String value;

  const MsSelectLevelType(this.value);
}

enum MsSelectLevelClickType {
  continueClick('continue'),
  back('back'),
  none('null');

  final String value;

  const MsSelectLevelClickType(this.value);
}

class MsSelectLevelTrackingParams {
  final String source;
  final MsSelectLevelType level;
  final MsSelectLevelClickType? clickType;
  final bool haveOccurredError;
  final String? errorMessage;

  MsSelectLevelTrackingParams({
    required this.source,
    this.level = MsSelectLevelType.none,
    this.clickType = MsSelectLevelClickType.none,
    this.haveOccurredError = false,
    this.errorMessage = '',
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'level': level.value,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.LABEL: source,
      AirbridgeAttribute.ACTION: clickType?.value,
    };
  }
}
