import 'package:monkey_stories/core/constants/constants.dart';

class LastLoginEntity {
  final LoginType loginType;
  final String? phone;
  final String? email;
  final String? token;
  final String? name;
  final String? appleUserCredential;
  final bool isSocial;

  const LastLoginEntity({
    required this.loginType,
    this.phone,
    this.email,
    this.token,
    this.name,
    this.appleUserCredential,
    this.isSocial = false,
  });

  factory LastLoginEntity.fromJson(Map<String, dynamic> json) {
    return LastLoginEntity(
      loginType: LoginType.fromValue(json['loginType']),
      phone: json['phone'],
      email: json['email'],
      token: json['token'],
      name: json['name'],
      appleUserCredential: json['appleUserCredential'],
      isSocial: json['isSocial'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginType': loginType.value,
      'phone': phone,
      'email': email,
      'token': token,
      'name': name,
      'appleUserCredential': appleUserCredential,
      'isSocial': isSocial,
    };
  }
}
