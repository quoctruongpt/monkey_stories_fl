import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

// Từ Khi user chọn bất kì mục nào trong cài đặt chung.
class MsGeneralSettingDetailTrackingUsecase
    extends UseCase<void, MsGeneralSettingDetailParams> {
  final TrackingRepository trackingRepository;

  MsGeneralSettingDetailTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsGeneralSettingDetailParams params,
  ) async {
    trackingRepository.pushEvent(
      eventName: 'ms_general_setting_detail',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsGeneralSettingDetailParams {
  final bool enableNotification;
  final int timeOnScreen;
  final bool hasClickedLanguage;
  final bool hasClickedBack;
  final bool hasClickedNotification;
  final bool hasClickedBackgroundMusic;
  final bool hasOccurredError;
  final String? errorMessage;

  MsGeneralSettingDetailParams({
    required this.enableNotification,
    required this.timeOnScreen,
    required this.hasClickedLanguage,
    required this.hasClickedBack,
    required this.hasClickedNotification,
    required this.hasClickedBackgroundMusic,
    required this.hasOccurredError,
    this.errorMessage,
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'enable_notification': enableNotification,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': hasOccurredError,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {
      AirbridgeAttribute.ACTION:
          'language:${hasClickedLanguage == true ? '1' : '0'}, back: ${hasClickedBack == true ? '1' : '0'}, notification: ${hasClickedNotification == true ? '1' : '0'}, background_music: ${hasClickedBackgroundMusic == true ? '1' : '0'}',
    };
  }
}
