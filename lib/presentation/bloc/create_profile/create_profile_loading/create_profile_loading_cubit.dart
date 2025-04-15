import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

part 'create_profile_loading_state.dart';

class CreateProfileLoadingCubit extends Cubit<CreateProfileLoadingState> {
  CreateProfileLoadingCubit()
    : super(
        const CreateProfileLoadingState(loadingProcess: LoadingProcess.init),
      );

  Timer? _progressTimer;
  Timer? _loadingTimer;

  void startLoading() {
    // Bắt đầu từ trạng thái init
    _updateLoadingProcess(LoadingProcess.init);

    // Danh sách các trạng thái theo thứ tự
    final loadingSteps = [
      LoadingProcess.createAccount,
      LoadingProcess.createProfile,
      LoadingProcess.updateSetting,
      LoadingProcess.done,
    ];

    int currentStep = 0;

    // Hủy timer cũ nếu có
    _loadingTimer?.cancel();

    // Tạo timer mới để thay đổi loadingProcess mỗi 2 giây
    _loadingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentStep < loadingSteps.length) {
        _updateLoadingProcess(loadingSteps[currentStep]);
        currentStep++;
      } else {
        // Đã hoàn thành tất cả các bước, hủy timer
        timer.cancel();
        _loadingTimer = null;
      }
    });
  }

  void _updateLoadingProcess(LoadingProcess loadingProcess) {
    emit(state.copyWith(loadingProcess: loadingProcess));

    // Cập nhật giá trị progress dựa trên loadingProcess
    double targetProgress;
    switch (loadingProcess) {
      case LoadingProcess.init:
        targetProgress = 0.1;
        break;
      case LoadingProcess.createAccount:
        targetProgress = 0.25;
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
    _loadingTimer?.cancel();
    return super.close();
  }
}
