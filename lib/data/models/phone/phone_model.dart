import 'package:monkey_stories/domain/entities/phone/phone_entity.dart';

class PhoneModel {
  final String countryCode;
  final String phoneNumber;

  PhoneModel({required this.countryCode, required this.phoneNumber});

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      countryCode: json['country_code'],
      phoneNumber: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'country_code': countryCode, 'phone': phoneNumber};
  }

  PhoneEntity toEntity() {
    return PhoneEntity(countryCode: countryCode, phone: phoneNumber);
  }
}
