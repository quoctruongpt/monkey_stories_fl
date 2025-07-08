// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsSignUpTrackingUsecase extends UseCase<void, MsSignUpTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsSignUpTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsSignUpTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_sign_up',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

class MsSignUpTrackingParams {
  final String type;
  final String phone;
  final bool isSuccessful;
  final bool haveClickedSignIn;
  final bool haveOccurredError;
  final String? errorMessage;

  MsSignUpTrackingParams({
    this.type = '',
    this.phone = '',
    this.isSuccessful = true,
    this.haveClickedSignIn = false,
    this.haveOccurredError = false,
    this.errorMessage = '',
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'phone': phone,
      'is_successful': isSuccessful,
      'have_clicked_sign_in': haveClickedSignIn,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.LABEL: type};
  }
}
