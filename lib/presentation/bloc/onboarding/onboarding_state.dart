part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.years = const [],
    this.yearSelected,
    this.name,
    this.levelId,
  });

  final List<int> years;
  final int? yearSelected;
  final String? name;
  final int? levelId;

  OnboardingState copyWith({
    List<int>? years,
    int? yearSelected,
    String? name,
    int? levelId,
  }) {
    return OnboardingState(
      years: years ?? this.years,
      yearSelected: yearSelected ?? this.yearSelected,
      name: name ?? this.name,
      levelId: levelId ?? this.levelId,
    );
  }

  @override
  List<Object?> get props => [years, yearSelected, name, levelId];
}
