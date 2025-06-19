import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

// ghi nhận khi user view màn hình báo cáo học tập
class MsLearningReportScreenTrackingUsecase
    extends UseCase<void, MsLearningReportScreenParams> {
  final TrackingRepository trackingRepository;

  MsLearningReportScreenTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsLearningReportScreenParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_learning_report_screen',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsLearningReportScreenParams {
  final int profileId;
  final int timeOnScreen;
  final bool hasOccurredError;
  final String? errorMessage;
  final bool hasClickedSwitchProfile;

  MsLearningReportScreenParams({
    required this.profileId,
    required this.timeOnScreen,
    required this.hasOccurredError,
    this.errorMessage,
    required this.hasClickedSwitchProfile,
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
    return {AirbridgeAttribute.ACTION: hasClickedSwitchProfile};
  }
}
