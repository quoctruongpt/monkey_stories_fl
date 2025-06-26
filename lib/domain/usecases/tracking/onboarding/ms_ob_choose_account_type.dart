import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

// Khi user hành động trên màn hình chọn tài khoản
class MsObChooseAccountTypeTrackingUsecase
    extends UseCase<void, MsObChooseAccountTypeParams> {
  final TrackingRepository trackingRepository;

  MsObChooseAccountTypeTrackingUsecase({required this.trackingRepository});

  @override
  Future<Either<Failure, void>> call(MsObChooseAccountTypeParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_ob_choose_account_type',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
      isPushAirbridge: true,
      isPushKinesis: true,
    );

    return right(null);
  }
}

class MsObChooseAccountTypeParams {
  final String tagName01;
  final ClickType? clickType;
  final int timeOnScreen;

  MsObChooseAccountTypeParams({
    required this.tagName01,
    this.clickType,
    required this.timeOnScreen,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'tag_name_01': tagName01, 'time_on_screen': timeOnScreen};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType?.value};
  }
}

enum ClickType {
  login('login'),
  startNow('start_now'),
  killApp('kill_app'),
  activeCode('active_code'),
  language('change_language');

  final String value;

  const ClickType(this.value);
}
