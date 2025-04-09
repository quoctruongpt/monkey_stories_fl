import 'package:monkey_stories/models/location/location_info.dart';

class RegisterLocationData {
  final String deviceId;
  final String ip;
  final String countryCode;
  final LocationInfo location;
  final bool showFeatureFeedback;
  final String ac;

  RegisterLocationData({
    required this.deviceId,
    required this.ip,
    required this.countryCode,
    required this.location,
    required this.showFeatureFeedback,
    required this.ac,
  });

  factory RegisterLocationData.fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      return RegisterLocationData(
        deviceId: json['device_id'] as String? ?? '',
        ip: json['ip'] as String? ?? '',
        countryCode: json['country_code'] as String? ?? '',
        location: LocationInfo.fromJson(json['location']),
        showFeatureFeedback: json['show_feature_feedback'] as bool? ?? false,
        ac: json['ac'] as String? ?? '',
      );
    }
    // Return a default/empty object if JSON is invalid
    return RegisterLocationData(
      deviceId: '',
      ip: '',
      countryCode: '',
      location: LocationInfo(
        ip: '',
        countryCode: '',
        countryName: '',
        regionName: '',
        cityName: '',
        latitude: 0.0,
        longitude: 0.0,
        isVn: false,
      ),
      showFeatureFeedback: false,
      ac: '',
    );
  }
}
