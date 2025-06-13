part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  const BottomNavigationState({
    this.isBottomNavVisible = true,
    this.isFabElevated = false,
  });

  final bool isBottomNavVisible;
  final bool isFabElevated;

  BottomNavigationState copyWith({
    bool? isBottomNavVisible,
    bool? isFabElevated,
  }) {
    return BottomNavigationState(
      isBottomNavVisible: isBottomNavVisible ?? this.isBottomNavVisible,
      isFabElevated: isFabElevated ?? this.isFabElevated,
    );
  }

  @override
  List<Object?> get props => [isBottomNavVisible, isFabElevated];
}
