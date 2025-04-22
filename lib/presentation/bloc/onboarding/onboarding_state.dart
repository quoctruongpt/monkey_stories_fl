part of 'onboarding_cubit.dart';

enum OnboardingProgress {
  init,
  createAccount,
  createProfile,
  updateSetting,
  loadUpdate,
  done,
}

class OnboardingError {
  final String message;
  final OnboardingProgress onboardingProgress;

  OnboardingError({required this.message, required this.onboardingProgress});
}

class OnboardingState extends Equatable {
  const OnboardingState({
    this.years = const [],
    this.yearSelected,
    this.name,
    this.levelId,
    this.progress = 0,
    this.onboardingProgress = OnboardingProgress.init,
    this.error,
  });

  final List<int> years;
  final int? yearSelected;
  final String? name;
  final int? levelId;
  final double progress;
  final OnboardingProgress onboardingProgress;
  final OnboardingError? error;

  OnboardingState copyWith({
    List<int>? years,
    int? yearSelected,
    String? name,
    int? levelId,
    double? progress,
    OnboardingProgress? onboardingProgress,
    OnboardingError? error,
  }) {
    return OnboardingState(
      years: years ?? this.years,
      yearSelected: yearSelected ?? this.yearSelected,
      name: name ?? this.name,
      levelId: levelId ?? this.levelId,
      progress: progress ?? this.progress,
      onboardingProgress: onboardingProgress ?? this.onboardingProgress,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    years,
    yearSelected,
    name,
    levelId,
    progress,
    onboardingProgress,
    error,
  ];
}
