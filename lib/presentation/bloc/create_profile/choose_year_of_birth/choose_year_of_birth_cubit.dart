import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/utils/profile.dart';

part 'choose_year_of_birth_state.dart';

class ChooseYearOfBirthCubit extends Cubit<ChooseYearOfBirthState> {
  ChooseYearOfBirthCubit() : super(const ChooseYearOfBirthState()) {
    emit(state.copyWith(years: ProfileUtil.getNearYears()));
  }

  void onChangeYear(int value) {
    emit(state.copyWith(yearSelected: value));
  }
}
