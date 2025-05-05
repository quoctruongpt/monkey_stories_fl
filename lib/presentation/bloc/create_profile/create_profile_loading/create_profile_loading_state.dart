part of 'create_profile_loading_cubit.dart';

enum LoadingProcess { init, createProfile, updateSetting, done }

class CreateProfileLoadingState extends Equatable {
  const CreateProfileLoadingState({
    required this.loadingProcess,
    this.progress = 0,
    this.callApiProfileError,
  });

  final LoadingProcess loadingProcess;
  final double progress;
  final String? callApiProfileError;

  CreateProfileLoadingState copyWith({
    LoadingProcess? loadingProcess,
    double? progress,
    String? callApiProfileError,
  }) {
    return CreateProfileLoadingState(
      loadingProcess: loadingProcess ?? this.loadingProcess,
      progress: progress ?? this.progress,
      callApiProfileError: callApiProfileError ?? this.callApiProfileError,
    );
  }

  @override
  List<Object?> get props => [loadingProcess, progress, callApiProfileError];
}
