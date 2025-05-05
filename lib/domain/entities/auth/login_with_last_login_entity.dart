import 'package:monkey_stories/core/constants/constants.dart';

class LoginWithLastLoginEntity {
  final LoginType loginType;
  final String email;
  final String token;

  LoginWithLastLoginEntity({
    required this.loginType,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {'type': loginType.value, 'email': email, 'token': token};
  }
}
