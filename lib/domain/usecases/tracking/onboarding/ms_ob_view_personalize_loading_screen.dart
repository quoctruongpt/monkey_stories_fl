// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user view màn hình loading cá nhân hóa bài học
class MsObViewPersonalizeLoadingScreenTrackingUsecase
    extends UseCase<void, MsObViewPersonalizeLoadingScreenParams> {
  final TrackingRepository trackingRepository;

  MsObViewPersonalizeLoadingScreenTrackingUsecase({
    required this.trackingRepository,
  });

  @override
  Future<Either<Failure, void>> call(
    MsObViewPersonalizeLoadingScreenParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_view_personalize_loading_screen',
      customProperties: params.toCustomProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );

    return right(null);
  }
}

class MsObViewPersonalizeLoadingScreenParams {
  final int timeOnScreen;

  MsObViewPersonalizeLoadingScreenParams({required this.timeOnScreen});

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }
}
