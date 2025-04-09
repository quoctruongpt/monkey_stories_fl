class LocationInfo {
  final String ip;
  final String countryCode; // Using the key 'countryCodeHere' from JSON
  final String countryName;
  final String regionName;
  final String cityName;
  final double latitude; // Use double for coordinates
  final double longitude;
  final bool isVn;

  LocationInfo({
    required this.ip,
    required this.countryCode,
    required this.countryName,
    required this.regionName,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.isVn,
  });

  factory LocationInfo.fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      return LocationInfo(
        ip: json['ip'] as String? ?? '',
        // Note: Using 'countryCodeHere' key from the provided JSON sample
        countryCode: json['countryCodeHere'] as String? ?? '',
        countryName: json['country_name'] as String? ?? '',
        regionName: json['region_name'] as String? ?? '',
        cityName: json['city_name'] as String? ?? '',
        // Convert num to double, default to 0.0
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        isVn: json['is_vn'] as bool? ?? false,
      );
    }
    // Return a default/empty object if JSON is not a map or null
    return LocationInfo(
      ip: '',
      countryCode: '',
      countryName: '',
      regionName: '',
      cityName: '',
      latitude: 0.0,
      longitude: 0.0,
      isVn: false,
    );
  }
}
