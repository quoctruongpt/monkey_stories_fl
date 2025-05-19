class SharedPrefKeys {
  SharedPrefKeys._(); // Private constructor to prevent instantiation

  static const String languageCode = 'language_code';
  static const String isDarkMode = 'isDarkMode';
  static const String deviceId = 'deviceId';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
  static const String userId = 'userId';
  static const String lastLogin = 'lastLogin';
  static const String leaveContact = 'leaveContact';
  static const String profileList = 'profileList';
  static const String currentProfile = 'currentProfile';
  static const String countryCode = 'countryCode';
  static const String purchasedProducts = 'purchasedProducts';
  static const String purchasedLatest = 'purchasedLatest';
  static const String hasLoggedBefore = 'hasLoggedBefore';
  static const String isBackgroundMusicEnabled = 'isBackgroundMusicEnabled';
  static const String isNotificationEnabled = 'isNotificationEnabled';
  static const String scheduleDayOfWeek = 'scheduleDayOfWeek';
  static const String scheduleTime = 'scheduleTime';
}

final keysToKeep = [
  SharedPrefKeys.languageCode,
  SharedPrefKeys.isDarkMode,
  SharedPrefKeys.deviceId,
  SharedPrefKeys.lastLogin,
  SharedPrefKeys.countryCode,
  SharedPrefKeys.purchasedProducts,
  SharedPrefKeys.purchasedLatest,
  SharedPrefKeys.hasLoggedBefore,
];
