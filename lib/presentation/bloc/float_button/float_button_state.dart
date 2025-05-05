part of 'float_button_cubit.dart';

class FloatButtonState {
  final double x;
  final double y;
  final double targetX;
  final double targetY;
  final bool isAnimating;

  FloatButtonState({
    required this.x,
    required this.y,
    required this.targetX,
    required this.targetY,
    required this.isAnimating,
  });

  FloatButtonState copyWith({
    double? x,
    double? y,
    double? targetX,
    double? targetY,
    bool? isAnimating,
  }) {
    return FloatButtonState(
      x: x ?? this.x,
      y: y ?? this.y,
      targetX: targetX ?? this.targetX,
      targetY: targetY ?? this.targetY,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}
