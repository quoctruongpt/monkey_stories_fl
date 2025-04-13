part of 'app_cubit.dart';

class AppState extends Equatable {
  final bool isOrientationLoading;
  final String languageCode;
  final bool isDarkMode;
  final String? deviceId;

  const AppState({
    required this.isOrientationLoading,
    required this.isDarkMode,
    this.languageCode = 'vi',
    this.deviceId,
  });

  AppState copyWith({
    bool? isOrientationLoading,
    String? languageCode,
    bool? isDarkMode,
    String? deviceId,
  }) {
    return AppState(
      isOrientationLoading: isOrientationLoading ?? this.isOrientationLoading,
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  List<Object?> get props => [
    isOrientationLoading,
    languageCode,
    isDarkMode,
    deviceId,
  ];
}
