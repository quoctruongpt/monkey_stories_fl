class LocationModel {
  final String ip;
  final String countryCode;
  final String countryName;
  final String regionName;
  final String cityName;
  final bool isVietNam;

  LocationModel({
    required this.ip,
    required this.countryCode,
    required this.countryName,
    required this.regionName,
    required this.cityName,
    required this.isVietNam,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      ip: json['ip'],
      countryCode: json['countryCodeHere'],
      countryName: json['country_name'],
      regionName: json['region_name'],
      cityName: json['city_name'],
      isVietNam: json['is_vn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'countryCodeHere': countryCode,
      'country_name': countryName,
      'region_name': regionName,
      'city_name': cityName,
      'is_vn': isVietNam,
    };
  }
}
