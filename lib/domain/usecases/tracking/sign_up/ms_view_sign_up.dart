// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Xem màn hình đăng ký
class MsViewSignUpTrackingUsecase extends UseCase<void, NoParams> {
  final TrackingRepository _trackingRepository;

  MsViewSignUpTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_view_sign_up',
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}
