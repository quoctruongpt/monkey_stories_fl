import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
// Import network info if needed for online/offline check
// import 'package:monkey_stories/core/network/network_info.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  // final NetworkInfo networkInfo; // Inject if needed

  AuthRepositoryImpl({
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    // No network check needed here, just check local cache
    try {
      final result = await localDataSource.isLoggedIn();
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  // Implement other AuthRepository methods (login, logout...) here
  // They would typically check networkInfo, call remote/local datasources,
  // handle exceptions and convert them to Failures.
}
