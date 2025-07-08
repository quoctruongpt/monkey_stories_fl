// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';

class DeleteDataFolderUsecase extends UseCase<void, DeleteDataFolderParams> {
  final SystemSettingsRepository systemRepository;

  DeleteDataFolderUsecase({required this.systemRepository});

  @override
  Future<Either<Failure, void>> call(DeleteDataFolderParams params) async {
    return await systemRepository.deleteDataFolder(params.path);
  }
}

class DeleteDataFolderParams {
  final String path;

  DeleteDataFolderParams({required this.path});
}
