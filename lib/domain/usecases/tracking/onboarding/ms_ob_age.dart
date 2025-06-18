import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsObAgeTrackingUsecase extends UseCase<void, MsObAgeParams> {
  final TrackingRepository trackingRepository;

  MsObAgeTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(MsObAgeParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_age',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );

    return right(null);
  }
}

class MsObAgeParams {
  final int age;
  final int timeOnScreen;
  final String source;
  final ClickType? clickType;

  MsObAgeParams({
    required this.age,
    required this.timeOnScreen,
    required this.source,
    this.clickType,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'age': age, 'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.LABEL: source,
      AirbridgeAttribute.ACTION: clickType?.value,
    };
  }
}

enum ClickType {
  continued('continue'),
  back('back');

  final String value;

  const ClickType(this.value);
}
