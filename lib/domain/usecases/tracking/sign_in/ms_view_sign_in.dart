// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Xem màn hình đăng nhập
class MsViewSignInTrackingUsecase extends UseCase<void, NoParams> {
  final TrackingRepository _trackingRepository;

  MsViewSignInTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_view_sign_in',
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}
