// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user click vào bất kì nút nào ở section truyện đã đọc theo cấp độ
class MsLearningReportStoriesLevelTrackingUsecase
    extends UseCase<void, MsLearningReportStoriesLevelParams> {
  final TrackingRepository trackingRepository;

  MsLearningReportStoriesLevelTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsLearningReportStoriesLevelParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_learning_report_stories_level',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsLearningReportStoriesLevelParams {
  final StoriesLevelClickType clickType;
  final int profileId;
  final int timeOnScreen;
  final bool hasOccurredError;
  final String? errorMessage;

  MsLearningReportStoriesLevelParams({
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

enum StoriesLevelClickType {
  thisWeek('this_week'),
  thisMonth('total'),
  showMore('show_more'),
  showLess('show_less');

  final String value;

  const StoriesLevelClickType(this.value);
}
