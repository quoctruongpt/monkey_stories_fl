// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user click vào bất kì nút nào ở section tiến độ học phonics của bé
class MsLearningReportPhonicsTrackingUsecase
    extends UseCase<void, MsLearningReportPhonicsParams> {
  final TrackingRepository trackingRepository;

  MsLearningReportPhonicsTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsLearningReportPhonicsParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_learning_report_phonics',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsLearningReportPhonicsParams {
  final PhonicsClickType clickType;
  final int profileId;
  final int timeOnScreen;
  final bool hasOccurredError;
  final String? errorMessage;

  MsLearningReportPhonicsParams({
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

enum PhonicsClickType {
  showMore('show_more'),
  showLess('show_less');

  final String value;

  const PhonicsClickType(this.value);
}
