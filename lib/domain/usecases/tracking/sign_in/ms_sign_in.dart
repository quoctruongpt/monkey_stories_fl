import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsSignInTrackingUsecase extends UseCase<void, MsSignInTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsSignInTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsSignInTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_sign_in',
      customProperties: params.toJson(),
    );
    return right(null);
  }
}

class MsSignInTrackingParams {
  final String type;
  final String username;
  final String phone;
  final String email;
  final bool isSuccess;
  final bool forgotPassword;
  final String? errorMessage;
  final bool haveClickedSignUp;
  final bool haveClickedActiveCode;
  final bool haveOccurredError;

  MsSignInTrackingParams({
    this.type = '',
    this.username = '',
    this.phone = '',
    this.email = '',
    this.isSuccess = true,
    this.forgotPassword = false,
    this.errorMessage = '',
    this.haveClickedSignUp = false,
    this.haveClickedActiveCode = false,
    this.haveOccurredError = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'username': username,
      'phone': phone,
      'is_successful': isSuccess,
      'forgot_password': forgotPassword,
      'error_message': errorMessage,
      'have_clicked_sign_up': haveClickedSignUp,
      'have_clicked_active_code': haveClickedActiveCode,
      'have_occurred_error': haveOccurredError,
      'email': email,
    };
  }
}
