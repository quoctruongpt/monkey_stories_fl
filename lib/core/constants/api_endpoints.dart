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
  static const String confirmPassword = '/app/api/v1/account/confirm-pw';

  // Account
  static const String loadUpdate = '/app/api/v4/account/load-update';
  static const String updateUserInfo = '/app/api/v1/account/update-info';
  static const String settingUser = '/app/api/v1/sync/user-setting';

  // Profile
  static const String updateProfile = '/app/api/v3/account/update-profile';
  static const String getListProfile = '/app/api/v3/account/profile-list';

  // Leave Contact
  static const String saveContact = '/app/api/v2/account/order-register-custom';

  // Course
  static const String activeCourse = '/app/api/v1/account/active-course';

  // Purchased
  static const String verifyPurchase = '/device/api/v1/payinapp/verify-store';

  // Active license
  static const String verifyLicenseCode =
      'app/api/v1/account/verify-license-code';
  static const String linkCodToAccount =
      'app/api/v1/account/link-user-crm-to-account';

  // Notification
  static const String registerDevice = '/device/api/v1/fcm/save';

  static const String learningReport = '/report/ms2/parent_report';
}
