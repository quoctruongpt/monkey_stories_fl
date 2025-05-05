import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monkey_stories/core/validators/name.dart';

part 'input_name_state.dart';

class InputNameCubit extends Cubit<InputNameState> {
  InputNameCubit() : super(const InputNameState(name: NameValidator.pure()));

  void onChangeName(String value) {
    final name = NameValidator.dirty(value);
    emit(state.copyWith(name: name));
  }
}
