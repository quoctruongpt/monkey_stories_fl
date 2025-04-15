import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<String> getLanguage();
  Future<void> saveLanguage(String languageCode);

  Future<ThemeMode> getTheme();
  Future<void> saveTheme(ThemeMode themeMode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getLanguage() async {
    try {
      final languageCode = sharedPreferences.getString(
        SharedPrefKeys.languageCode,
      );
      return languageCode ?? 'vi'; // Trả về default 'vi' nếu null
    } catch (e) {
      throw CacheException(message: 'Failed to get language code');
    }
  }

  @override
  Future<void> saveLanguage(String languageCode) async {
    try {
      await sharedPreferences.setString(
        SharedPrefKeys.languageCode,
        languageCode,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save language code');
    }
  }

  @override
  Future<ThemeMode> getTheme() async {
    try {
      final isDarkMode = sharedPreferences.getBool(SharedPrefKeys.isDarkMode);
      if (isDarkMode == null) {
        return ThemeMode.system; // Default hoặc ThemeMode.light tùy bạn
      } else {
        return isDarkMode ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      throw CacheException(message: 'Failed to get theme mode');
    }
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    try {
      bool isDarkMode;
      switch (themeMode) {
        case ThemeMode.dark:
          isDarkMode = true;
          break;
        case ThemeMode.light:
          isDarkMode = false;
          break;
        case ThemeMode.system:
          // Lưu trạng thái system hoặc một giá trị đặc biệt?
          // Hoặc không lưu gì và để getTheme() trả về system?
          // Tạm thời lưu false (tương đương light) khi chọn system.
          isDarkMode = false;
          break;
      }
      await sharedPreferences.setBool(SharedPrefKeys.isDarkMode, isDarkMode);
    } catch (e) {
      throw CacheException(message: 'Failed to save theme mode');
    }
  }
}
