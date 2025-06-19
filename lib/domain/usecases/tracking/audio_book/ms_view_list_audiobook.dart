import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user view màn hình danh sách audiobooks
class MsViewListAudiobookTrackingUsecase
    extends UseCase<void, MsViewListAudiobookParams> {
  final TrackingRepository trackingRepository;

  MsViewListAudiobookTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsViewListAudiobookParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_view_list_audiobook',
      customProperties: params.toCustomProperties(),
    );
    return const Right(null);
  }
}

class MsViewListAudiobookParams {
  final int timeOnScreen;

  MsViewListAudiobookParams({required this.timeOnScreen});

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }
}
