import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'dart:async';

import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'create_profile_loading_state.dart';

final logger = Logger('CreateProfileLoadingCubit');

class CreateProfileLoadingCubit extends Cubit<CreateProfileLoadingState> {
  final ProfileCubit _profileCubit;

  CreateProfileLoadingCubit({required ProfileCubit profileCubit})
    : _profileCubit = profileCubit,

      super(
        const CreateProfileLoadingState(loadingProcess: LoadingProcess.init),
      );

  Timer? _progressTimer;

  void startLoading(String name, int yearOfBirth, int levelId) async {
    try {
      // Bắt đầu từ trạng thái init
      _updateLoadingProcess(LoadingProcess.init);

      // Danh sách các trạng thái theo thứ tự
      await _createProfile(name, yearOfBirth, levelId);

      _updateLoadingProcess(LoadingProcess.done);
    } catch (e) {}
  }

  Future<void> _createProfile(String name, int yearOfBirth, int levelId) async {
    try {
      await _profileCubit.addProfile(name, yearOfBirth, levelId);

      _updateLoadingProcess(LoadingProcess.createProfile);
    } catch (e) {
      logger.severe('error: $e');
      emit(state.copyWith(callApiProfileError: e.toString()));
      rethrow; // Re-throw lỗi để có thể bắt ở tầng trên
    }
  }

  void _updateLoadingProcess(LoadingProcess loadingProcess) {
    emit(state.copyWith(loadingProcess: loadingProcess));

    // Cập nhật giá trị progress dựa trên loadingProcess
    double targetProgress;
    switch (loadingProcess) {
      case LoadingProcess.init:
        targetProgress = 0.1;
        break;
      case LoadingProcess.createProfile:
        targetProgress = 0.5;
        break;
      case LoadingProcess.updateSetting:
        targetProgress = 0.75;
        break;
      case LoadingProcess.done:
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
