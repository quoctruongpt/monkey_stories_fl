import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class GetSoundTrackUseCase implements UseCase<bool, NoParams> {
  final SettingsRepository repository;

  GetSoundTrackUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getBackgroundMusic();
  }
}
