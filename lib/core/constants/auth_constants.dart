class AuthConstants {
  AuthConstants._();

  static const int phoneExistCode = 201;
  static const int pwErrorCode = 202;
  static const int userNotFoundCode = 201;
  static const int manyRequestOtp = 202;
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

  static LoginType fromValue(int value) {
    return LoginType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LoginType.phone,
    );
  }
}

enum ForgotPasswordType {
  phone(1),
  email(2);

  final int value;
  const ForgotPasswordType(this.value);
}
