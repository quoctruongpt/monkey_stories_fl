import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';

class GetCountryCodeUsecase extends UseCase<String, NoParams> {
  final SystemSettingsRepository systemRepository;

  GetCountryCodeUsecase({required this.systemRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await systemRepository.getCountryCode();
  }
}
