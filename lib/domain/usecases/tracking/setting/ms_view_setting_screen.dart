import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// ghi nhận khi user view màn hình cài đặt
class MsViewSettingScreenTrackingUsecase
    extends UseCase<void, MsViewSettingScreenParams> {
  final TrackingRepository trackingRepository;

  MsViewSettingScreenTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsViewSettingScreenParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_view_setting_screen',
      customProperties: params.toCustomProperties(),
    );
    return const Right(null);
  }
}

class MsViewSettingScreenParams {
  final bool hasEmail;
  final bool hasPhone;

  MsViewSettingScreenParams({required this.hasEmail, required this.hasPhone});

  Map<String, dynamic> toCustomProperties() {
    return {'have_email': hasEmail, 'have_phone': hasPhone};
  }
}
