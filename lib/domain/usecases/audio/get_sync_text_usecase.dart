import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';
import 'package:monkey_stories/domain/repositories/audio_repository.dart';

class GetSyncTextUsecase
    extends UseCase<List<SyncTextData>, GetSyncTextParams> {
  final AudioRepository audioRepository;

  GetSyncTextUsecase({required this.audioRepository});

  @override
  Future<Either<Failure, List<SyncTextData>>> call(
    GetSyncTextParams params,
  ) async {
    try {
      final result = await audioRepository.getSyncTextData(
        params.audioPath,
        params.content,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GetSyncTextParams {
  final String audioPath;
  final String content;

  GetSyncTextParams({required this.audioPath, required this.content});
}
