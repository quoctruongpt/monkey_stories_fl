import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/core/utils/profile.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetLanguageUseCase _getLanguageUseCase;

  OnboardingCubit({required GetLanguageUseCase getLanguageUseCase})
    : _getLanguageUseCase = getLanguageUseCase,
      super(const OnboardingState()) {
    emit(state.copyWith(years: ProfileUtil.getNearYears()));
    initialName();
  }

  Future<void> initialName() async {
    final result = await _getLanguageUseCase.call(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(name: 'Bé')),
      (language) =>
          emit(state.copyWith(name: language == 'vi' ? 'Bé' : 'Baby')),
    );
  }

  void onChangeYear(int year) {
    emit(state.copyWith(yearSelected: year));
  }

  void onChangeLevel(int levelId) {
    emit(state.copyWith(levelId: levelId));
  }
}
