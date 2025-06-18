import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class UpdateProfileUsecase
    extends UseCase<ProfileEntity, UpdateProfileUsecaseParams> {
  final ProfileRepository _profileRepository;

  UpdateProfileUsecase(this._profileRepository);

  @override
  Future<Either<ServerFailureWithCode, ProfileEntity>> call(
    UpdateProfileUsecaseParams params,
  ) async {
    return _profileRepository.updateProfile(
      id: params.id,
      name: params.name,
      yearOfBirth: params.yearOfBirth,
      localAvatarPath: params.localAvatarPath,
    );
  }
}

class UpdateProfileUsecaseParams {
  final int id;
  final String? name;
  final int? yearOfBirth;
  final String? localAvatarPath;

  UpdateProfileUsecaseParams({
    required this.id,
    this.name,
    this.yearOfBirth,
    this.localAvatarPath,
  });
}
