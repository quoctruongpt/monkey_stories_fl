import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/shared_pref_keys.dart';
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
    final languageCode = prefs.getString(SharedPrefKeys.languageCode) ?? 'vi';
    emit(state.copyWith(languageCode: languageCode));
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.languageCode, languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(SharedPrefKeys.isDarkMode) ?? false;
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = !state.isDarkMode;
    await prefs.setBool(SharedPrefKeys.isDarkMode, isDarkMode);
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  void updateDeviceInfo({String? deviceId}) {
    emit(state.copyWith(deviceId: deviceId));
  }
}
