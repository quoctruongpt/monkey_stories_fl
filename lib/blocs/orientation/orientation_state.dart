part of 'orientation_cubit.dart';

class OrientationState {
  final AppOrientation orientation;

  OrientationState({required this.orientation});

  OrientationState copyWith({AppOrientation? orientation}) {
    return OrientationState(orientation: orientation ?? this.orientation);
  }
}
