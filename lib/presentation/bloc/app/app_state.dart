part of 'app_cubit.dart';

class AppState extends Equatable {
  final bool isOrientationLoading;
  final String languageCode;
  final bool isDarkMode;
  final String? deviceId;
  final AppOrientation? orientation;

  const AppState({
    required this.isOrientationLoading,
    required this.isDarkMode,
    this.languageCode = 'vi',
    this.deviceId,
    this.orientation,
  });

  AppState copyWith({
    bool? isOrientationLoading,
    String? languageCode,
    bool? isDarkMode,
    String? deviceId,
    AppOrientation? orientation,
  }) {
    return AppState(
      isOrientationLoading: isOrientationLoading ?? this.isOrientationLoading,
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      deviceId: deviceId ?? this.deviceId,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  List<Object?> get props => [
    isOrientationLoading,
    languageCode,
    isDarkMode,
    deviceId,
    orientation,
  ];
}
