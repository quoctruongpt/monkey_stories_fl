import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SaveLanguageUseCase implements UseCase<void, String> {
  final SettingsRepository repository;

  SaveLanguageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String languageCode) async {
    return await repository.saveLanguage(languageCode);
  }
}
