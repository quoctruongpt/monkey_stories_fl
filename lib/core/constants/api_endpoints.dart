class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String registerLocation = '/device/api/v4/location/register';
  static const String login = '/app/api/v3/account/authen/login';
  static const String checkPhoneNumber = '/app/api/v1/account/check-phone-used';
  static const String signUp = '/app/api/v2/account/authen/register';
  static const String sendOtp = '/app/api/v1/account/send-opt-verify-pw';
  static const String verifyOtpWithEmail =
      '/app/api/v1/account/verify-opt-for-email';
  static const String verifyOtpWithPhone =
      '/app/api/v1/account/verify-opt-for-phone';
  static const String changePassword =
      '/app/api/v1/account/change-forgot-password';

  // Account
  static const String loadUpdate = '/app/api/v4/account/load-update';

  // Profile
  static const String updateProfile = '/app/api/v3/account/update-profile';
  static const String getListProfile = '/app/api/v3/account/profile-list';

  // Leave Contact
  static const String saveContact = '/app/api/v2/account/order-register-custom';

  // Course
  static const String activeCourse = '/app/api/v1/account/active-course';

  // Purchased
  static const String verifyPurchase = '/device/api/v1/payinapp/verify-store';
}
