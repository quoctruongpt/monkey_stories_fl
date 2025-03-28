import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(isOrientationLoading: false)) {
    _loadSavedLanguage();
  }

  void showLoading() {
    emit(state.copyWith(isOrientationLoading: true));

    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(isOrientationLoading: false));
    });
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'vi';
    emit(state.copyWith(languageCode: languageCode));
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }
}
