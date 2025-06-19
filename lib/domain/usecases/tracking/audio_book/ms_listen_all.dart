import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user view màn hình Nghe tất cả audiobooks
class MsListenAllTrackingUsecase extends UseCase<void, MsListenAllParams> {
  final TrackingRepository trackingRepository;

  MsListenAllTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsListenAllParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_listen_all',
      customProperties: params.toCustomProperties(),
    );
    return const Right(null);
  }
}

class MsListenAllParams {
  final bool autoNextOrNot;
  final int setTime;

  MsListenAllParams({required this.autoNextOrNot, required this.setTime});

  Map<String, dynamic> toCustomProperties() {
    return {
      'auto_next_or_not': autoNextOrNot ? 'yes' : 'no',
      'set_time': '${setTime}p',
    };
  }
}
