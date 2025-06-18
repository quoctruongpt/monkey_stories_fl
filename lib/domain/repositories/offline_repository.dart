import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

abstract class OfflineRepository {
  Future<void> setLastOnlineTime();
  Future<Either<Failure, bool>> isOfflinePeriodExpired();
}
