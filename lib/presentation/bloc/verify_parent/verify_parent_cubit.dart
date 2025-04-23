import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_parent_state.dart';

final numberOfCharacters = 3;

class VerifyParentCubit extends Cubit<VerifyParentState> {
  VerifyParentCubit() : super(const VerifyParentState());

  void generateRandomNumbers() {
    emit(
      state.copyWith(
        randomNumbers: List.generate(
          numberOfCharacters,
          (_) => Random().nextInt(9) + 1,
        ),
      ),
    );
  }

  void onNumberPressed(int number) {
    if (state.input.length < numberOfCharacters) {
      emit(state.copyWith(input: state.input + number.toString()));
    }

    if (state.input.length == numberOfCharacters) {
      emit(
        state.copyWith(isCorrect: state.input == state.randomNumbers.join('')),
      );
    }
  }

  void onBackspacePressed() {
    if (state.input.isNotEmpty) {
      emit(
        state.copyWith(input: state.input.substring(0, state.input.length - 1)),
      );
    }
  }
}
