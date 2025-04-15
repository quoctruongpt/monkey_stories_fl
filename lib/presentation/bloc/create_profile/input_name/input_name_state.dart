part of 'input_name_cubit.dart';

class InputNameState extends Equatable {
  const InputNameState({required this.name});

  final NameValidator name;

  InputNameState copyWith({NameValidator? name}) {
    return InputNameState(name: name ?? this.name);
  }

  @override
  List<Object?> get props => [name];
}
