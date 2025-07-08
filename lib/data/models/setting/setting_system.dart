// Project imports:
import 'package:monkey_stories/domain/entities/setting/setting_system_entity.dart';

class SettingSystem {
  bool? isSubmitting;

  SettingSystem(this.isSubmitting);

  SettingSystem.fromJson(Map<String, dynamic> json) {
    isSubmitting = json['is_submitting'];
  }

  SettingSystemEntity toEntity() {
    return SettingSystemEntity(isSubmitting: isSubmitting);
  }

  Map<String, dynamic> toJson() {
    return {'is_submitting': isSubmitting};
  }
}
