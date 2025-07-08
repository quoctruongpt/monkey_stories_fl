// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/constants/remote_config.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/remote_config/remote_config_remote_data_source.dart';
import 'package:monkey_stories/domain/repositories/remote_config_repository.dart';

class RemoteConfigRepositoryImpl extends RemoteConfigRepository {
  final RemoteConfigRemoteDataSource _remoteConfigRemoteDataSource;
  RemoteConfigRepositoryImpl(this._remoteConfigRemoteDataSource);

  @override
  Future<Either<Failure, void>> initialize() async {
    return _remoteConfigRemoteDataSource.initialize().then(
      (value) => Right(value),
      onError: (error) => Left(ServerFailure(message: error.toString())),
    );
  }

  @override
  Future<Either<Failure, String>> getPassDebug() async {
    try {
      final password = _remoteConfigRemoteDataSource.getString(
        RemoteConfigKeys.debugPassword,
      );
      return Right(password);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
