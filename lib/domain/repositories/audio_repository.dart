import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';

abstract class AudioRepository {
  Future<List<SyncTextData>> getSyncTextData(String audioPath, String content);
}
