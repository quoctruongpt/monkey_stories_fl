import 'package:flutter/material.dart'; // Cần cho ThemeMode

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class GetThemeUseCase implements UseCase<ThemeMode, NoParams> {
  final SettingsRepository repository;

  GetThemeUseCase(this.repository);

  @override
  Future<Either<Failure, ThemeMode>> call(NoParams params) async {
    return await repository.getTheme();
  }
}
