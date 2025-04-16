import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/api_status.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/profile/profile_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl({required this.profileRemoteDataSource});

  @override
  Future<Either<ServerFailureWithCode, ProfileEntity>> createProfile(
    String name,
    int yearOfBirth,
  ) async {
    final response = await profileRemoteDataSource.updateProfile(
      name,
      yearOfBirth,
      null,
      null,
      null,
    );

    if (response.status == ApiStatus.success) {
      return right(response.data!.toEntity(name, yearOfBirth));
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}
