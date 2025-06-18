import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SaveSoundTrackUsecase implements UseCase<void, bool> {
  final SettingsRepository repository;

  SaveSoundTrackUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(bool params) async {
    return repository.saveBackgroundMusic(params);
  }
}
