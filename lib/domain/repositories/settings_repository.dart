import 'package:flutter/material.dart'; // Cần cho ThemeMode
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, String>> getLanguage();
  Future<Either<Failure, void>> saveLanguage(String languageCode);
  Future<Either<Failure, ThemeMode>> getTheme();
  Future<Either<Failure, void>> saveTheme(ThemeMode themeMode);
  Future<Either<Failure, bool>> getBackgroundMusic();
  Future<Either<Failure, void>> saveBackgroundMusic(bool isEnabled);
}
