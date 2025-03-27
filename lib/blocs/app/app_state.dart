part of 'app_cubit.dart';

class AppState {
  final bool isOrientationLoading;

  AppState({required this.isOrientationLoading});

  AppState copyWith({bool? isOrientationLoading}) {
    return AppState(
      isOrientationLoading: isOrientationLoading ?? this.isOrientationLoading,
    );
  }
}
