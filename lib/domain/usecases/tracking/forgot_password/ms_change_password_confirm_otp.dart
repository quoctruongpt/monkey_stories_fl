import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'have_clicked_type': clickType.value,
      'account_type': accountType.value,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
      'have_verified_OTP_successfully': haveVerifiedOTPSuccessfully,
      'count_time_verify_OTP': countTimeVerifyOTP,
    };
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
      customProperties: params.toJson(),
    );
    return right(null);
  }
}
