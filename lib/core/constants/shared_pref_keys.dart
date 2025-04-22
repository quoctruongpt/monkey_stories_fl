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
}

final keysToKeep = [
  SharedPrefKeys.languageCode,
  SharedPrefKeys.isDarkMode,
  SharedPrefKeys.deviceId,
  SharedPrefKeys.lastLogin,
];
