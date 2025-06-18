import 'package:flutter/services.dart'; // Cần cho DeviceOrientation
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

abstract class SystemSettingsRepository {
  Future<Either<Failure, void>> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  );

  Future<Either<Failure, String>> getCountryCode();
}
