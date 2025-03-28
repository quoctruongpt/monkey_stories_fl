import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(isOrientationLoading: false, isDarkMode: false)) {
    _loadSavedLanguage();
    _loadTheme();
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

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = !state.isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
    emit(state.copyWith(isDarkMode: isDarkMode));
  }
}
