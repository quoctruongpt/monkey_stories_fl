part of 'app_cubit.dart';

class AppState extends Equatable {
  final bool isOrientationLoading;
  final String languageCode;
  final bool isDarkMode;
  final String? deviceId;
  final AppOrientation? orientation;
  final bool isBackgroundMusicEnabled;
  final bool isNotificationEnabled;
  final String appVersion;

  const AppState({
    required this.isOrientationLoading,
    required this.isDarkMode,
    this.languageCode = 'vi',
    this.deviceId,
    this.orientation,
    this.isBackgroundMusicEnabled = true,
    this.isNotificationEnabled = true,
    this.appVersion = '',
  });

  AppState copyWith({
    bool? isOrientationLoading,
    String? languageCode,
    bool? isDarkMode,
    String? deviceId,
    AppOrientation? orientation,
    bool? isBackgroundMusicEnabled,
    bool? isNotificationEnabled,
    String? appVersion,
  }) {
    return AppState(
      isOrientationLoading: isOrientationLoading ?? this.isOrientationLoading,
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      deviceId: deviceId ?? this.deviceId,
      orientation: orientation ?? this.orientation,
      isBackgroundMusicEnabled:
          isBackgroundMusicEnabled ?? this.isBackgroundMusicEnabled,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [
    isOrientationLoading,
    languageCode,
    isDarkMode,
    deviceId,
    orientation,
    isBackgroundMusicEnabled,
    isNotificationEnabled,
    appVersion,
  ];
}
