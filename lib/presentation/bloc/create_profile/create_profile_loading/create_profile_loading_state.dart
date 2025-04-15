part of 'create_profile_loading_cubit.dart';

enum LoadingProcess { init, createAccount, createProfile, updateSetting, done }

class CreateProfileLoadingState extends Equatable {
  const CreateProfileLoadingState({
    required this.loadingProcess,
    this.progress = 0,
  });

  final LoadingProcess loadingProcess;
  final double progress;

  CreateProfileLoadingState copyWith({
    LoadingProcess? loadingProcess,
    double? progress,
  }) {
    return CreateProfileLoadingState(
      loadingProcess: loadingProcess ?? this.loadingProcess,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [loadingProcess, progress];
}
