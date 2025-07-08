import 'package:flutter/material.dart'; // Cần cho ThemeMode

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/setting/schedule_entity.dart';
import 'package:monkey_stories/domain/entities/setting/setting_system_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, String>> getLanguage();
  Future<Either<Failure, void>> saveLanguage(String languageCode);
  Future<Either<Failure, ThemeMode>> getTheme();
  Future<Either<Failure, void>> saveTheme(ThemeMode themeMode);
  Future<Either<Failure, bool>> getBackgroundMusic();
  Future<Either<Failure, void>> saveBackgroundMusic(bool isEnabled);
  Future<Either<Failure, void>> saveSchedule(ScheduleEntity schedule);
  Future<Either<Failure, SettingSystemEntity>> getSettingSystem();
}
