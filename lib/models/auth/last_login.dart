import 'package:monkey_stories/core/constants/constants.dart';

class LastLogin {
  final LoginType? loginType;
  final String? phone;
  final String? email;
  final String? appleId;
  final String? token;
  final String? name;

  LastLogin({
    this.loginType,
    this.phone,
    this.email,
    this.appleId,
    this.token,
    this.name,
  });

  factory LastLogin.fromJson(Map<String, dynamic> json) {
    final loginTypeValue = json['loginType'] as int?;
    LoginType? loginType;
    if (loginTypeValue != null) {
      try {
        loginType = LoginType.values.firstWhere(
          (e) => e.value == loginTypeValue,
        );
      } catch (e) {
        loginType = null;
      }
    }
    return LastLogin(
      loginType: loginType,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      appleId: json['appleId'] as String?,
      token: json['token'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginType': loginType?.value,
      'phone': phone,
      'email': email,
      'appleId': appleId,
      'token': token,
      'name': name,
    };
  }
}
