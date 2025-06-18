import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

enum MsUpdatePasswordClickType {
  update('update'),
  back('back'),
  none('null');

  final String value;
  const MsUpdatePasswordClickType(this.value);
}

class MsUpdatePasswordTrackingParams {
  final MsUpdatePasswordClickType clickType;
  final AccountType accountType;
  final int timeOnScreen;
  final bool haveOccurredError;
  final String? errorMessage;
  final bool isSuccessful;

  MsUpdatePasswordTrackingParams({
    this.clickType = MsUpdatePasswordClickType.none,
    required this.accountType,
    required this.timeOnScreen,
    this.haveOccurredError = false,
    this.errorMessage,
    this.isSuccessful = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'have_clicked_type': clickType.value,
      'account_type': accountType.value,
      'time_on_screen': timeOnScreen,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
      'is_successful': isSuccessful,
    };
  }
}

class MsUpdatePasswordTrackingUseCase
    extends UseCase<void, MsUpdatePasswordTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsUpdatePasswordTrackingUseCase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(
    MsUpdatePasswordTrackingParams params,
  ) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_change_password_update_password',
      customProperties: params.toJson(),
    );
    return right(null);
  }
}
