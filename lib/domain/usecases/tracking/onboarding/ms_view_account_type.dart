import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsViewAccountTypeTrackingUsecase extends UseCase<void, NoParams> {
  final TrackingRepository trackingRepository;

  MsViewAccountTypeTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    trackingRepository.pushEvent(eventName: 'ms_view_account_type');

    return right(null);
  }
}
