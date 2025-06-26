import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

enum MsChangePasswordConfirmOTPClickType {
  confirm('confirm'),
  back('back'),
  resend('resend'),
  none('null');

  final String value;
  const MsChangePasswordConfirmOTPClickType(this.value);
}

class MsChangePasswordConfirmOTPTrackingParams {
  final MsChangePasswordConfirmOTPClickType clickType;
  final AccountType accountType;
  final int timeOnScreen;
  final bool haveOccurredError;
  final String? errorMessage;
  final bool haveVerifiedOTPSuccessfully;
  final int countTimeVerifyOTP;

  MsChangePasswordConfirmOTPTrackingParams({
    this.clickType = MsChangePasswordConfirmOTPClickType.none,
    required this.accountType,
    required this.timeOnScreen,
    this.haveOccurredError = false,
    this.errorMessage,
    required this.haveVerifiedOTPSuccessfully,
    required this.countTimeVerifyOTP,
  });

  Map<String, dynamic> toCustomProperties() {
    return {
      'account_type': accountType.value,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
      'have_verified_OTP_successfully': haveVerifiedOTPSuccessfully,
      'count_time_verify_OTP': countTimeVerifyOTP,
    };
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType.value};
  }
}

class MsChangePasswordConfirmOTPTrackingUseCase
    extends UseCase<void, MsChangePasswordConfirmOTPTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsChangePasswordConfirmOTPTrackingUseCase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsChangePasswordConfirmOTPTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_change_password_confirm_otp',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return right(null);
  }
}
