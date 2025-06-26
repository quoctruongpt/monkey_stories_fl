import 'package:monkey_stories/core/constants/purchased.dart';

class DefaultProperties {
  final PurchasedStatus? userType;
  final int? age;
  final int? userId;
  final int? profileId;
  final int? deviceId;
  final String? country;
  final String? deviceType;
  final String? platform;
  final String? osName;
  final String? osVersion;
  final String? appVersion;
  final String? channel;
  final String? campaign;

  DefaultProperties({
    this.userType,
    this.age,
    this.userId,
    this.profileId,
    this.deviceId,
    this.country,
    this.deviceType,
    this.platform,
    this.osName,
    this.osVersion,
    this.appVersion,
    this.channel,
    this.campaign,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType?.value,
      'age': age,
      'user_id': userId,
      'profile_id': profileId,
      'device_id': deviceId,
      'country': country,
      'device_type': deviceType,
      'platform': platform,
      'os_name': osName,
      'os_version': osVersion,
      'app_version': appVersion,
      'channel': channel,
      'campaign': campaign,
    };
  }
}
