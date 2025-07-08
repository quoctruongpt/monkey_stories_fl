// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';

abstract class OfflineRepository {
  Future<void> setLastOnlineTime();
  Future<Either<Failure, bool>> isOfflinePeriodExpired();
}
