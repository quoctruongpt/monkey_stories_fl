import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

// ghi nhận khi user click vào bất kì nút nào ở section tiến độ học RC của bé
class MsLearningReportRCTrackingUsecase
    extends UseCase<void, MsLearningReportRCParams> {
  final TrackingRepository trackingRepository;

  MsLearningReportRCTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsLearningReportRCParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_learning_report_rc',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsLearningReportRCParams {
  final RCClickType clickType;
  final int profileId;
  final int timeOnScreen;
  final bool hasOccurredError;
  final String? errorMessage;

  MsLearningReportRCParams({
    required this.clickType,
    required this.profileId,
    required this.timeOnScreen,
    required this.hasOccurredError,
    this.errorMessage,
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'profile_id': profileId,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': hasOccurredError,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType.value};
  }
}

enum RCClickType {
  showMore('show_more'),
  showLess('show_less');

  final String value;

  const RCClickType(this.value);
}
