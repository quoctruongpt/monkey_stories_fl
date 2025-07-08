// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Ghi nhận khi hiển thị pop up thông báo ba mẹ sẽ bị mất hồ sơ trial, ba mẹ có muốn đăng nhập không
class MsSignInPopupWarningUsecase
    extends UseCase<void, MsSignInPopupWarningParams> {
  final TrackingRepository _trackingRepository;

  MsSignInPopupWarningUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsSignInPopupWarningParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_sign_in_popup_warning_lose_account_popup',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );
    return right(null);
  }
}

enum MsSignInPopupWarningClickType {
  close('close'),
  cancel('cancel'),
  signIn('sign_in'),
  unknown('unknown');

  final String value;

  const MsSignInPopupWarningClickType(this.value);
}

class MsSignInPopupWarningParams {
  final MsSignInPopupWarningClickType? clickType;
  final bool? haveOccurredError;
  final String? errorMessage;

  MsSignInPopupWarningParams({
    this.clickType = MsSignInPopupWarningClickType.unknown,
    this.haveOccurredError = false,
    this.errorMessage = '',
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType?.value};
  }
}
