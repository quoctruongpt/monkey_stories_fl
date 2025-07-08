// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/setting/setting_system_entity.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class GetSettingSystemUseCase
    implements UseCase<SettingSystemEntity, NoParams> {
  final SettingsRepository repository;

  GetSettingSystemUseCase(this.repository);

  @override
  Future<Either<Failure, SettingSystemEntity>> call(NoParams params) async {
    return await repository.getSettingSystem();
  }
}
