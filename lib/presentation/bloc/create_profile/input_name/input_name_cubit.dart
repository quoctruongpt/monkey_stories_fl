import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monkey_stories/core/validators/name.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'input_name_state.dart';

class InputNameCubit extends Cubit<InputNameState> {
  final ProfileCubit _profileCubit;
  InputNameCubit({required ProfileCubit profileCubit})
    : _profileCubit = profileCubit,
      super(const InputNameState(name: NameValidator.pure()));

  void onChangeName(String value) {
    final name = NameValidator.dirty(value);
    emit(state.copyWith(name: name, hasNameExisted: hasNameExisted(value)));
  }

  bool hasNameExisted(String name) {
    return _profileCubit.state.profiles.any(
      (profile) => profile.name == name.trim(),
    );
  }
}
