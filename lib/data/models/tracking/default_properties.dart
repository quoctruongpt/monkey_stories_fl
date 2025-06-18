import 'package:monkey_stories/core/constants/purchased.dart';

class DefaultProperties {
  final PurchasedStatus? userType;
  final int? age;
  final int? userId;
  final int? profileId;
  final int? deviceId;

  DefaultProperties({
    this.userType,
    this.age,
    this.userId,
    this.profileId,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType?.value,
      'age': age,
      'user_id': userId,
      'profile_id': profileId,
      'device_id': deviceId,
    };
  }
}
