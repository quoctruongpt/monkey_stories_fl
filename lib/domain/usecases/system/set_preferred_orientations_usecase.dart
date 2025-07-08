// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';

class SetPreferredOrientationsUseCase
    implements UseCase<void, List<DeviceOrientation>> {
  final SystemSettingsRepository repository;

  SetPreferredOrientationsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    List<DeviceOrientation> orientations,
  ) async {
    return await repository.setPreferredOrientations(orientations);
  }
}
