import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

class MsChangePasswordMethodTrackingUsecase
    extends UseCase<void, MsChangePasswordMethodTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsChangePasswordMethodTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsChangePasswordMethodTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_change_password_method_screen',
      customProperties: params.toJson(),
    );
    return right(null);
  }
}

enum MsChangePasswordMethodClickType {
  viaSms('via SMS'),
  viaEmail('via email'),
  back('back'),
  none('null');

  final String value;

  const MsChangePasswordMethodClickType(this.value);
}

class MsChangePasswordMethodTrackingParams {
  final MsChangePasswordMethodClickType clickType;
  final int timeOnScreen;
  final bool haveOccurredError;
  final String? errorMessage;
  final AccountType accountType;

  MsChangePasswordMethodTrackingParams({
    this.clickType = MsChangePasswordMethodClickType.none,
    required this.timeOnScreen,
    this.haveOccurredError = false,
    this.errorMessage = '',
    required this.accountType,
  });

  Map<String, dynamic> toJson() {
    return {
      'click_type': clickType.value,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
      'account_type': accountType.value,
    };
  }
}
