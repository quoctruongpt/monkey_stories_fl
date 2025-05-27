import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/api_status.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.profileLocalDataSource,
  });

  @override
  Future<Either<ServerFailureWithCode, ProfileEntity>> createProfile(
    String name,
    int yearOfBirth,
    int levelId,
  ) async {
    final response = await profileRemoteDataSource.updateProfile(
      name,
      yearOfBirth,
      null,
      null,
      null,
    );

    if (response.status == ApiStatus.success) {
      await profileLocalDataSource.addProfile(
        response.data!.toEntity(name, yearOfBirth),
      );
      await profileLocalDataSource.cacheCurrentProfile(response.data!.id);
      return right(response.data!.toEntity(name, yearOfBirth));
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }

  @override
  Future<Either<ServerFailureWithCode, List<ProfileEntity>>>
  getListProfile() async {
    final response = await profileRemoteDataSource.getListProfile();

    if (response.status == ApiStatus.success) {
      final list = response.data!.map((e) => e.toEntity()).toList();
      await profileLocalDataSource.saveListProfile(list);
      return right(list);
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }

  @override
  Future<Either<CacheFailure, int?>> getCurrentProfile() async {
    try {
      final response = await profileLocalDataSource.getCurrentProfile();
      return right(response);
    } catch (e) {
      return left(const CacheFailure());
    }
  }

  @override
  Future<Either<ServerFailureWithCode, ProfileEntity>> updateProfile({
    required int id,
    String? name,
    int? yearOfBirth,
    String? localAvatarPath,
  }) async {
    final response = await profileRemoteDataSource.updateProfile(
      name,
      yearOfBirth,
      null,
      localAvatarPath,
      id,
    );

    if (response.status == ApiStatus.success) {
      return right(response.data!.toEntity(name ?? '', yearOfBirth ?? 0));
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }

  @override
  Future<Either<CacheFailure, List<ProfileEntity>>>
  getListProfileLocal() async {
    try {
      final response = await profileLocalDataSource.getListProfile();
      return right(response);
    } catch (e) {
      return left(const CacheFailure());
    }
  }

  @override
  Future<Either<CacheFailure, void>> saveCurrentProfile(int profileId) async {
    await profileLocalDataSource.cacheCurrentProfile(profileId);
    return right(null);
  }
}
