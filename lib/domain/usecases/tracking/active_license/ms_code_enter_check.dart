// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// User thực hiện hành động quét QR
class MsCodeEnterCheckTrackingUsecase
    extends UseCase<void, MsCodeEnterCheckParams> {
  final TrackingRepository trackingRepository;

  MsCodeEnterCheckTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsCodeEnterCheckParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_code_enter_check',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsCodeEnterCheckParams {
  final String source;
  final int timeOnScreen;
  final bool enterStatus;
  final String? errorMessage;

  MsCodeEnterCheckParams({
    required this.source,
    required this.timeOnScreen,
    required this.enterStatus,
    this.errorMessage,
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'time_on_screen': timeOnScreen,
      'enter_status': enterStatus,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: source};
  }
}
