import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/phone/phone_model.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';

class User {
  final int userId;
  final int maxProfile;
  final LoginType loginType;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? country;
  final PhoneModel? phoneInfo;

  User({
    required this.userId,
    required this.loginType,
    required this.maxProfile,
    this.email,
    this.name,
    this.phone,
    this.avatar,
    this.country,
    this.phoneInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['users_id'],
      loginType: LoginType.fromValue(json['identity_login']),
      maxProfile: json['max_profile'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      avatar: json['avatar'],
      country: json['country'],
      phoneInfo:
          json['phone_info'] != null
              ? PhoneModel.fromJson({
                'country_code': json['phone_info']['phone_code'],
                'phone': json['phone_info']['phone'],
              })
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'login_type': loginType.value,
      'max_profile': maxProfile,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'country': country,
      'phone_info': phoneInfo?.toJson(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      loginType: loginType,
      maxProfile: maxProfile,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      country: country,
      phoneInfo: phoneInfo?.toEntity(),
    );
  }
}
