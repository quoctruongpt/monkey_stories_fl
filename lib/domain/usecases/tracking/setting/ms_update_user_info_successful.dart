import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

// Khi user chỉnh sửa thành công trong mục thông tin ba mẹ (ấn vào lưu)
class MsUpdateUserInfoSuccessfulTrackingUsecase
    extends UseCase<void, MsUpdateUserInfoSuccessfulParams> {
  final TrackingRepository trackingRepository;

  MsUpdateUserInfoSuccessfulTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsUpdateUserInfoSuccessfulParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_update_user_info_successful',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsUpdateUserInfoSuccessfulParams {
  final bool? hasClickedName;
  final bool? hasClickedEmail;
  final bool? hasClickedPhone;
  final bool? hasClickedPassword;
  final int timeOnScreen;

  MsUpdateUserInfoSuccessfulParams({
    this.hasClickedName,
    this.hasClickedEmail,
    this.hasClickedPhone,
    this.hasClickedPassword,
    required this.timeOnScreen,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.ACTION:
          '${hasClickedEmail == true ? 'email,' : ''}${hasClickedPhone == true ? 'phone,' : ''}${hasClickedPassword == true ? 'password' : ''}',
    };
  }
}
