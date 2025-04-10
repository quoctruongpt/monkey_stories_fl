class LoginResponseData {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final bool isOnBoard;
  final String tokenToChangePassword;
  final bool isMaxProfile;
  final int countProfile;
  final String? fToken;
  final String? phoneOrder;

  LoginResponseData({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.isOnBoard,
    required this.tokenToChangePassword,
    required this.isMaxProfile,
    required this.countProfile,
    this.fToken,
    this.phoneOrder,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      userId: json['user_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      isOnBoard: json['is_on_board'],
      tokenToChangePassword: json['token_to_change_pw'],
      isMaxProfile: json['is_max_profile'],
      countProfile: json['count_profile'],
      fToken: json['f_token'],
      phoneOrder: json['phone_order'],
    );
  }
}

class LoginRequestData {
  final String? phone;
  final String? email;
  final String? password;
  final String? token;
  final LoginType loginType;

  LoginRequestData({
    this.phone,
    this.email,
    this.password,
    required this.loginType,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'type': loginType.value,
      'access_token': token,
    };
  }
}

enum LoginType {
  facebook(1),
  email(2),
  phone(3),
  skip(4),
  userCrm(5),
  apple(6);

  final int value;
  const LoginType(this.value);
}
