import 'package:flutter/services.dart'; // Cần cho DeviceOrientation

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';

abstract class SystemSettingsRepository {
  Future<Either<Failure, void>> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  );

  Future<Either<Failure, String>> getCountryCode();

  Future<Either<Failure, void>> deleteDataFolder(String path);
}
