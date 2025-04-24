import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/domain/entities/phone/phone_entity.dart';

class UserEntity {
  final int userId;
  final int maxProfile;
  final LoginType loginType;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? country;
  final PhoneEntity? phoneInfo;

  UserEntity({
    required this.userId,
    required this.maxProfile,
    required this.loginType,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.country,
    this.phoneInfo,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['userId'],
      maxProfile: json['maxProfile'],
      loginType: LoginType.fromValue(json['loginType']),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      country: json['country'],
      phoneInfo:
          json['phoneInfo'] != null
              ? PhoneEntity.fromJson(json['phoneInfo'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'maxProfile': maxProfile,
      'loginType': loginType.value,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'country': country,
      'phoneInfo': phoneInfo?.toJson(),
    };
  }
}
