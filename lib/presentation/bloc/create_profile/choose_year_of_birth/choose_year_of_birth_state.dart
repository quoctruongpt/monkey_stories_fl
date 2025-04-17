part of 'choose_year_of_birth_cubit.dart';

class ChooseYearOfBirthState extends Equatable {
  const ChooseYearOfBirthState({this.years, this.yearSelected});

  final int? yearSelected;
  final List<int>? years;

  ChooseYearOfBirthState copyWith({int? yearSelected, List<int>? years}) {
    return ChooseYearOfBirthState(
      yearSelected: yearSelected ?? this.yearSelected,
      years: years ?? this.years,
    );
  }

  @override
  List<Object?> get props => [yearSelected, years];
}
