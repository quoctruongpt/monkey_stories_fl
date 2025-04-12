import 'package:monkey_stories/models/auth/login_data.dart';

class SignUpRequestData {
  final LoginType type;
  final String? password;
  final String? countryCode;
  final String? phone;

  SignUpRequestData({
    required this.type,
    this.password,
    this.countryCode,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'password': password,
      'country_code': countryCode,
      'phone': phone,
    };
  }
}

class SignUpResponseData {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final bool isOnboard;
  final bool isNewRegister;

  SignUpResponseData({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.isOnboard,
    required this.isNewRegister,
  });

  factory SignUpResponseData.fromJson(Map<String, dynamic> json) {
    return SignUpResponseData(
      userId: json['user_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      isOnboard: json['is_on_board'],
      isNewRegister: json['is_new_register'],
    );
  }
}
