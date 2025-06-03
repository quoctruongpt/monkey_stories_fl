import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class MsProfileNameTrackingUsecase
    extends UseCase<void, MsProfileNameTrackingParams> {
  final TrackingRepository _trackingRepository;

  MsProfileNameTrackingUsecase(this._trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsProfileNameTrackingParams params) async {
    _trackingRepository.pushEvent(
      eventName: 'ms_profile_name',
      customProperties: params.toJson(),
    );
    return right(null);
  }
}

enum MsProfileNameClickType {
  continueClick('continue'),
  back('back'),
  none('null');

  final String value;

  const MsProfileNameClickType(this.value);
}

class MsProfileNameTrackingParams {
  final String source;
  final MsProfileNameClickType clickType;
  final bool haveOccurredError;
  final String? errorMessage;

  MsProfileNameTrackingParams({
    required this.source,
    this.clickType = MsProfileNameClickType.none,
    this.haveOccurredError = false,
    this.errorMessage = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'click_type': clickType.value,
      'have_occurred_error': haveOccurredError,
      'error_message': errorMessage,
    };
  }
}
