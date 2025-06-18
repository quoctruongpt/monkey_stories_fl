import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/setting/schedule_entity.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SaveScheduleUsecase extends UseCase<void, ScheduleEntity> {
  final SettingsRepository settingsRepository;

  SaveScheduleUsecase({required this.settingsRepository});

  @override
  Future<Either<Failure, void>> call(ScheduleEntity params) async {
    return settingsRepository.saveSchedule(params);
  }
}
