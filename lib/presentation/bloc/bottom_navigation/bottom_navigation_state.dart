part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  const BottomNavigationState({this.isBottomNavVisible = true});

  final bool isBottomNavVisible;

  BottomNavigationState copyWith({bool? isBottomNavVisible}) {
    return BottomNavigationState(
      isBottomNavVisible: isBottomNavVisible ?? this.isBottomNavVisible,
    );
  }

  @override
  List<Object?> get props => [isBottomNavVisible];
}
