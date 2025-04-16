class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String registerLocation = '/device/api/v4/location/register';
  static const String login = '/app/api/v3/account/authen/login';
  static const String checkPhoneNumber = '/app/api/v1/account/check-phone-used';
  static const String signUp = '/app/api/v2/account/authen/register';

  // Account
  static const String loadUpdate = '/app/api/v4/account/load-update';

  // Profile
  static const String updateProfile = '/app/api/v3/account/update-profile';
}
