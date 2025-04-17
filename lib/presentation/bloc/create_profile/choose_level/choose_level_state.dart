part of 'choose_level_cubit.dart';

class ChooseLevelState extends Equatable {
  const ChooseLevelState({this.levelSelected});

  final int? levelSelected;

  ChooseLevelState copyWith({int? levelSelected}) {
    return ChooseLevelState(levelSelected: levelSelected ?? this.levelSelected);
  }

  @override
  List<Object?> get props => [levelSelected];
}
