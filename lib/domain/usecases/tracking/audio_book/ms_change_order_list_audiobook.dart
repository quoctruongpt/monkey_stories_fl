// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user thay đổi thứ tự danh sách audiobooks
class MsChangeOrderListAudiobookTrackingUsecase
    extends UseCase<void, NoParams> {
  final TrackingRepository trackingRepository;

  MsChangeOrderListAudiobookTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    trackingRepository.pushEvent(eventName: 'ms_change_order_list_audiobook');
    return const Right(null);
  }
}
