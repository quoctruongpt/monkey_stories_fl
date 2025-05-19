import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<ServerFailureWithCode, ProfileEntity>> createProfile(
    String name,
    int yearOfBirth,
    int levelId,
  );

  Future<Either<ServerFailureWithCode, List<ProfileEntity>>> getListProfile();

  Future<Either<CacheFailure, int?>> getCurrentProfile();

  Future<Either<CacheFailure, List<ProfileEntity>>> getListProfileLocal();

  Future<Either<ServerFailureWithCode, ProfileEntity>> updateProfile({
    required int id,
    String? name,
    int? yearOfBirth,
    String? localAvatarPath,
  });
}
