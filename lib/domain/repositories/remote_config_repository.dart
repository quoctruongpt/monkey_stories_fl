// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';

abstract class RemoteConfigRepository {
  Future<Either<Failure, void>> initialize();
  Future<Either<Failure, String>> getPassDebug();
}
