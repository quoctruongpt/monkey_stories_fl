// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Bắn lên ngay khi user thoát màn hình update hồ sơ học
class MsUpdateProfilesTrackingUsecase
    extends UseCase<void, MsUpdateProfilesParams> {
  final TrackingRepository trackingRepository;

  MsUpdateProfilesTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsUpdateProfilesParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_update_profiles',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsUpdateProfilesParams {
  final int profileId;
  final bool hasOccurredError;
  final String? errorMessage;
  final int timeOnScreen;
  final bool isSuccess;
  final bool hasClickedName;
  final bool hasClickedYoB;
  final bool hasClickedBack;

  MsUpdateProfilesParams({
    required this.profileId,
    required this.hasOccurredError,
    this.errorMessage,
    required this.timeOnScreen,
    required this.isSuccess,
    required this.hasClickedName,
    required this.hasClickedYoB,
    required this.hasClickedBack,
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'profile_id': profileId,
      'have_occurred_error': hasOccurredError,
      'error_message': errorMessage,
      'time_on_screen': timeOnScreen,
      'is_success': isSuccess,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.ACTION:
          'profile_name:${hasClickedName == true ? '1' : '0'}, yob: ${hasClickedYoB == true ? '1' : '0'}, back: ${hasClickedBack == true ? '1' : '0'}',
    };
  }
}
