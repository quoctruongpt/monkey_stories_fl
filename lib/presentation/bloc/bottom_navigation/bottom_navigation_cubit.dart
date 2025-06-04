import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(const BottomNavigationState());

  void setBottomNavVisible(bool isVisible) {
    emit(state.copyWith(isBottomNavVisible: isVisible));
  }
}
