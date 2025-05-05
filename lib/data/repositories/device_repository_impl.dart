import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
// Import network info if needed
// import 'package:monkey_stories/core/network/network_info.dart';
import 'package:monkey_stories/domain/repositories/device_repository.dart';

final logger = Logger('DeviceRepositoryImpl');

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;
  final DeviceLocalDataSource localDataSource;
  final SystemLocalDataSource systemLocalDataSource;
  // final NetworkInfo networkInfo;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.systemLocalDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> registerDevice() async {
    // 1. Check if device ID already exists locally
    try {
      final localDeviceId = await localDataSource.getDeviceId();
      if (localDeviceId != null && localDeviceId.isNotEmpty) {
        logger.info('Device ID already exists: $localDeviceId'); // Logging
        return Right(localDeviceId);
      }
    } on CacheException {
      // Log error, but proceed to register remotely
      logger.severe(
        'CacheException while getting device ID, proceeding with remote registration.',
      );
    } catch (e) {
      // Log unexpected error, but proceed
      logger.severe(
        'Unexpected error getting local device ID: $e. Proceeding with remote registration.',
      );
    }

    // 2. If not found locally, register remotely (assuming network is available)
    // Optional: Add network check using NetworkInfo
    // if (await networkInfo.isConnected) { ... } else { return Left(NetworkFailure()); }
    try {
      logger.info('registerDevice');
      final result = await remoteDataSource.registerDevice();

      final remoteDeviceId = result.deviceId;
      final countryCode = result.countryCode;

      // 3. Cache the new device ID
      await localDataSource.cacheDeviceId(remoteDeviceId);
      systemLocalDataSource.cacheCountryCode(countryCode);
      return Right(remoteDeviceId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      // Failed to cache, but registration was successful (maybe return success anyway?)
      // Or return a specific failure? For now, let's return a CacheFailure.
      return const Left(
        CacheFailure(
          message: 'Failed to cache new device ID after registration.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              'Unexpected error during device registration: ${e.toString()}',
        ),
      );
    }
  }
}
