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
  final bool isDeletingData;
  final bool isDeletingDataSuccess;

  const AppState({
    required this.isOrientationLoading,
    required this.isDarkMode,
    this.languageCode = 'vi',
    this.deviceId,
    this.orientation,
    this.isBackgroundMusicEnabled = true,
    this.isNotificationEnabled = true,
    this.appVersion = '',
    this.isDeletingData = false,
    this.isDeletingDataSuccess = false,
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
    bool? isDeletingData,
    bool? isDeletingDataSuccess,
    bool? resetStatusDeletingData,
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
      isDeletingData:
          resetStatusDeletingData == true
              ? false
              : isDeletingData ?? this.isDeletingData,
      isDeletingDataSuccess:
          resetStatusDeletingData == true
              ? false
              : isDeletingDataSuccess ?? this.isDeletingDataSuccess,
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
    isDeletingData,
    isDeletingDataSuccess,
  ];
}
