import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'float_button_state.dart';

class FloatButtonCubit extends Cubit<FloatButtonState> {
  FloatButtonCubit()
    : super(
        FloatButtonState(
          x: 0,
          y: 100,
          targetX: 0,
          targetY: 100,
          isAnimating: false,
        ),
      );

  // Cập nhật vị trí khi kéo
  void updatePosition(double deltaX, double deltaY, Size screenSize) {
    final newX = (state.x + deltaX).clamp(0, screenSize.width - 50);
    final newY = (state.y + deltaY).clamp(0, screenSize.height - 50).toDouble();

    emit(
      state.copyWith(
        x: newX.toDouble(),
        y: newY,
        targetX: newX.toDouble(),
        targetY: newY,
      ),
    );
  }

  // Khi thả ra, tính toán và snap đến cạnh gần nhất
  void snapToNearestEdge(Size screenSize) {
    final startX = state.x;
    final startY = state.y;

    // Khoảng cách đến các cạnh
    final double distanceToLeft = startX;
    final double distanceToRight = screenSize.width - startX - 50;
    final double distanceToTop = startY;
    final double distanceToBottom = screenSize.height - startY - 50;

    // Tìm cạnh gần nhất
    final double minHorizontal =
        distanceToLeft < distanceToRight ? distanceToLeft : distanceToRight;
    final double minVertical =
        distanceToTop < distanceToBottom ? distanceToTop : distanceToBottom;

    double targetX = startX;
    double targetY = startY;

    if (minHorizontal < minVertical) {
      // Snap theo chiều ngang
      if (distanceToLeft < distanceToRight) {
        targetX = 0;
      } else {
        targetX = screenSize.width - 50;
      }
    } else {
      // Snap theo chiều dọc
      if (distanceToTop < distanceToBottom) {
        targetY = 0;
      } else {
        targetY = screenSize.height - 50;
      }
    }

    emit(state.copyWith(targetX: targetX, targetY: targetY, isAnimating: true));
  }

  // Cập nhật vị trí trong quá trình animation
  void updateAnimationProgress(double progress) {
    if (!state.isAnimating) return;

    final newX = state.x + (state.targetX - state.x) * progress;
    final newY = state.y + (state.targetY - state.y) * progress;

    emit(state.copyWith(x: newX, y: newY));

    // Kết thúc animation
    if (progress >= 1.0) {
      emit(state.copyWith(isAnimating: false));
    }
  }
}
