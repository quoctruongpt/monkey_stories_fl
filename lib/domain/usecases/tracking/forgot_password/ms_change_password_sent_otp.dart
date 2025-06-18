import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

enum MsChangePasswordSentOTPClickType {
  sendOTP('send_OTP'),
  back('back'),
  none('null');

  final String value;
  const MsChangePasswordSentOTPClickType(this.value);
}

class MsChangePasswordSentOTPTrackingParams {
  final MsChangePasswordSentOTPClickType clickType;
  final AccountType accountType;
  final int timeOnScreen;
  final bool haveOccurredError;
  final String? errorMessage;
  final bool isSuccessful;

  MsChangePasswordSentOTPTrackingParams({
    this.clickType = MsChangePasswordSentOTPClickType.none,
    required this.accountType,
    required this.timeOnScreen,
    this.haveOccurredError = false,
    this.errorMessage,
    required this.isSuccessful,
  });

  Map<String, dynamic> toJson() {
    return {
      'click_type': clickType.value,
      'account_type': accountType.value,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
      'is_successful': isSuccessful,
    };
  }
}

class MsChangePasswordSentOTPTrackingUseCase
    extends UseCase<void, MsChangePasswordSentOTPTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsChangePasswordSentOTPTrackingUseCase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsChangePasswordSentOTPTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_change_password_input_info_receive_otp',
      customProperties: params.toJson(),
    );
    return right(null);
  }
}
