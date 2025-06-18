import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';
import 'package:monkey_stories/domain/entities/tracking_event/airbridge_attribute.dart';

// Bắn lên khi click vào 1 mục bất kì trong màn parent setting
class MsParentSettingDetailTrackingUsecase
    extends UseCase<void, MsParentSettingDetailParams> {
  final TrackingRepository trackingRepository;

  MsParentSettingDetailTrackingUsecase(this.trackingRepository);

  @override
  Future<Either<Failure, void>> call(MsParentSettingDetailParams params) async {
    trackingRepository.pushEvent(
      eventName: 'ms_parent_setting_detail',
      customProperties: params.toCustomProperties(),
      semanticProperties: params.toSemanticProperties(),
    );
    return const Right(null);
  }
}

class MsParentSettingDetailParams {
  final bool hasEmail;
  final bool hasPhone;
  final ClickType clickType;

  MsParentSettingDetailParams({
    required this.hasEmail,
    required this.hasPhone,
    required this.clickType,
  });

  Map<String, dynamic> toCustomProperties() {
    return {'have_email': hasEmail, 'have_phone': hasPhone};
  }

  Map<String, dynamic> toSemanticProperties() {
    return {AirbridgeAttribute.ACTION: clickType.value};
  }
}

enum ClickType {
  parentInfo('parent_info'),
  userProfile('user_profile'),
  changePassword('change_password'),
  generalSettings('general_settings'),
  reminder('reminder'),
  monkeySupport('monkey_support'),
  signOut('sign_out'),
  licenseKey('license_key'),
  aboutMonkey('about_monkey'),
  termsOfUse('terms_of_use'),
  privacyPolicy('privacy_policy'),
  frequentlyAskedQuestions('frequently_asked_questions'),
  contactMonkey('contact_monkey');

  const ClickType(this.value);
  final String value;
}
