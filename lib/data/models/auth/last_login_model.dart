import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';

class LastLoginModel extends LastLoginEntity {
  LastLoginModel({
    required super.loginType,
    super.phone,
    super.email,
    super.token,
    super.name,
    super.appleUserCredential,
    super.isSocial,
  });

  factory LastLoginModel.fromJson(Map<String, dynamic> json) {
    return LastLoginModel(
      loginType: LoginType.fromValue(json['loginType']),
      phone: json['phone'],
      email: json['email'],
      token: json['token'],
      name: json['name'],
      appleUserCredential: json['appleUserCredential'],
      isSocial: json['isSocial'] ?? false,
    );
  }

  LastLoginEntity toEntity() {
    return LastLoginEntity(
      loginType: loginType,
      phone: phone,
      email: email,
      token: token,
      name: name,
      appleUserCredential: appleUserCredential,
      isSocial: isSocial,
    );
  }
}
