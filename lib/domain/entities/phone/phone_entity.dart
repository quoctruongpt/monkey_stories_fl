class PhoneEntity {
  final String countryCode;
  final String phone;

  PhoneEntity({required this.countryCode, required this.phone});

  factory PhoneEntity.fromJson(Map<String, dynamic> json) {
    return PhoneEntity(countryCode: json['countryCode'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'countryCode': countryCode, 'phone': phone};
  }
}
