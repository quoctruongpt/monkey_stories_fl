import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/core/utils/profile.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_skip_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetLanguageUseCase _getLanguageUseCase;
  final SignUpSkipUsecase _signUpSkipUsecase;
  final ProfileCubit _profileCubit;
  final AppCubit _appCubit;

  final UserCubit _userCubit;

  Timer? _progressTimer;

  OnboardingCubit({
    required GetLanguageUseCase getLanguageUseCase,
    required SignUpSkipUsecase signUpSkipUsecase,
    required UserCubit userCubit,
    required ProfileCubit profileCubit,
    required AppCubit appCubit,
  }) : _getLanguageUseCase = getLanguageUseCase,
       _signUpSkipUsecase = signUpSkipUsecase,
       _userCubit = userCubit,
       _profileCubit = profileCubit,
       _appCubit = appCubit,
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

  Future<void> onStart() async {
    _updateLoadingProcess(OnboardingProgress.init);
    try {
      final signUpResult = await _signUpSkipUsecase.call(NoParams());

      if (signUpResult.isLeft()) {
        emit(
          state.copyWith(
            error: OnboardingError(
              message: 'create account failed',
              onboardingProgress: OnboardingProgress.createAccount,
            ),
          ),
        );
        return;
      }

      _updateLoadingProcess(OnboardingProgress.createAccount);

      _appCubit.changeLanguage(_appCubit.state.languageCode);
      await _profileCubit.addProfile(
        state.name ?? '',
        state.yearSelected ?? 0,
        state.levelId ?? 0,
      );

      _updateLoadingProcess(OnboardingProgress.createProfile);

      await _userCubit.loadUpdate();

      _updateLoadingProcess(OnboardingProgress.done);
    } catch (e) {
      emit(
        state.copyWith(
          error: OnboardingError(
            message: 'error',
            onboardingProgress: state.onboardingProgress,
          ),
        ),
      );
    }
  }

  void _updateLoadingProcess(OnboardingProgress loadingProcess) {
    emit(state.copyWith(onboardingProgress: loadingProcess));

    // Cập nhật giá trị progress dựa trên loadingProcess
    double targetProgress;
    switch (loadingProcess) {
      case OnboardingProgress.init:
        targetProgress = 0.1;
        break;
      case OnboardingProgress.createAccount:
        targetProgress = 0.25;
        break;
      case OnboardingProgress.createProfile:
        targetProgress = 0.5;
        break;
      case OnboardingProgress.updateSetting:
        targetProgress = 0.75;
        break;
      case OnboardingProgress.loadUpdate:
        targetProgress = 0.9;
        break;
      case OnboardingProgress.done:
        targetProgress = 1.0;
        break;
    }

    // Hủy timer hiện tại nếu có
    _progressTimer?.cancel();

    // Tăng dần progress đến giá trị mục tiêu
    final currentProgress = state.progress;
    if (targetProgress > currentProgress) {
      const animationDuration = Duration(milliseconds: 500);
      const steps = 20;
      final stepValue = (targetProgress - currentProgress) / steps;
      final stepDuration = Duration(
        milliseconds: animationDuration.inMilliseconds ~/ steps,
      );

      var stepCount = 0;
      _progressTimer = Timer.periodic(stepDuration, (timer) {
        stepCount++;
        final newProgress = currentProgress + (stepValue * stepCount);

        if (stepCount >= steps || newProgress >= targetProgress) {
          _updateProgress(targetProgress);
          timer.cancel();
          _progressTimer = null;
        } else {
          _updateProgress(newProgress);
        }
      });
    }
  }

  void _updateProgress(double progress) {
    emit(state.copyWith(progress: progress));
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
