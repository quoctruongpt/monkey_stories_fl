// Project imports:
import 'package:monkey_stories/data/datasources/audio/audio_local_data_source.dart';
import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';
import 'package:monkey_stories/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioLocalDataSource audioLocalDataSource;

  AudioRepositoryImpl({required this.audioLocalDataSource});

  @override
  Future<List<SyncTextData>> getSyncTextData(
    String audioPath,
    String content,
  ) async {
    return await audioLocalDataSource.getSyncTextData(audioPath, content);
  }
}
