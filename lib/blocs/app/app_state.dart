part of 'app_cubit.dart';

class AppState {
  final bool isOrientationLoading;
  final String languageCode;

  AppState({required this.isOrientationLoading, this.languageCode = 'vi'});

  AppState copyWith({bool? isOrientationLoading, String? languageCode}) {
    return AppState(
      isOrientationLoading: isOrientationLoading ?? this.isOrientationLoading,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
