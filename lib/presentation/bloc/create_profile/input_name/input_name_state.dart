part of 'input_name_cubit.dart';

class InputNameState extends Equatable {
  const InputNameState({required this.name, this.hasNameExisted = false});

  final NameValidator name;
  final bool hasNameExisted;

  InputNameState copyWith({NameValidator? name, bool? hasNameExisted}) {
    return InputNameState(
      name: name ?? this.name,
      hasNameExisted: hasNameExisted ?? this.hasNameExisted,
    );
  }

  @override
  List<Object?> get props => [name, hasNameExisted];
}
