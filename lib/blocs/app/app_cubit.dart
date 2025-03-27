import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(isOrientationLoading: false));

  void showLoading() {
    emit(state.copyWith(isOrientationLoading: true));

    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(isOrientationLoading: false));
    });
  }
}
