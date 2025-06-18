import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/network/network_info.dart';
import 'package:monkey_stories/data/datasources/offline/offline_local_data_source.dart';
import 'package:monkey_stories/domain/repositories/offline_repository.dart';

class OfflineRepositoryImpl implements OfflineRepository {
  final OfflineLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final int offlineDurationLimitDays = 3;

  OfflineRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> isOfflinePeriodExpired() async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      await localDataSource.setLastOnlineTime();
      return const Right(false);
    } else {
      final lastOnlineTimeMillis = await localDataSource.getLastOnlineTime();
      if (lastOnlineTimeMillis == null) {
        // If there's no last online time and the user is offline,
        // it implies they've been offline for too long.
        return const Right(true);
      }
      final lastOnlineTime = DateTime.fromMillisecondsSinceEpoch(
        lastOnlineTimeMillis,
      );
      final difference = DateTime.now().difference(lastOnlineTime);

      return Right(difference.inDays >= offlineDurationLimitDays);
    }
  }

  @override
  Future<void> setLastOnlineTime() async {
    return await localDataSource.setLastOnlineTime();
  }
}
