import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_level_state.dart';

class ChooseLevelCubit extends Cubit<ChooseLevelState> {
  ChooseLevelCubit() : super(const ChooseLevelState());

  void onPressedLevel(int level) {
    emit(state.copyWith(levelSelected: level));
  }
}
