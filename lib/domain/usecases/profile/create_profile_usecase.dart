import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class CreateProfileUsecase
    extends UseCase<ProfileEntity, CreateProfileUsecaseParams> {
  final ProfileRepository _profileRepository;

  CreateProfileUsecase(this._profileRepository);

  @override
  Future<Either<ServerFailureWithCode, ProfileEntity>> call(
    CreateProfileUsecaseParams params,
  ) async {
    return _profileRepository.createProfile(params.name, params.yearOfBirth);
  }
}

class CreateProfileUsecaseParams {
  final String name;
  final int yearOfBirth;

  CreateProfileUsecaseParams({required this.name, required this.yearOfBirth});
}
