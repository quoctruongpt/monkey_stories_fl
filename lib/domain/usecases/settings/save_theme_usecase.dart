import 'package:flutter/material.dart'; // Cần cho ThemeMode

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SaveThemeUseCase implements UseCase<void, ThemeMode> {
  final SettingsRepository repository;

  SaveThemeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ThemeMode themeMode) async {
    return await repository.saveTheme(themeMode);
  }
}
