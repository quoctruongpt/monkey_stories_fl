import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Bắn lên khi user kích hoạt mã trên app, từ tất cả các nguồn
class MsActivatedCodeTrackingUsecase
    extends UseCase<void, MsActivatedCodeParams> {
  final TrackingRepository trackingRepository;

  MsActivatedCodeTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsActivatedCodeParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_activated_code',
      customProperties: params.toCustomProperties(),
    );
    return const Right(null);
  }
}

class MsActivatedCodeParams {
  final String couponCode;

  MsActivatedCodeParams({required this.couponCode});

  Map<String, dynamic> toCustomProperties() {
    return {'coupon_code': couponCode};
  }
}
