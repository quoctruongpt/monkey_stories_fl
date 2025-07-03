import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';
import 'dart:convert';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:logging/logging.dart';

abstract class AudioLocalDataSource {
  Future<List<SyncTextData>> getSyncTextData(String audioPath, String content);
}

class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final Logger logger = Logger('AudioLocalDataSourceImpl');

  @override
  Future<List<SyncTextData>> getSyncTextData(
    String audioPath,
    String content,
  ) async {
    final session = await FFprobeKit.execute(
      '-v quiet -show_entries format_tags=comment -of default=noprint_wrappers=1:nokey=1 "$audioPath"',
    );
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      final comment = await session.getOutput();

      if (comment != null && comment.isNotEmpty) {
        try {
          final Map<String, dynamic> data = json.decode(comment.trim());
          final List<dynamic> fragments = data['fragments'];
          final List<SyncTextData> transcript = [];

          int lastIndex = 0;

          for (final fragment in fragments) {
            final String beginStr = fragment['begin'];
            final String endStr = fragment['end'];
            final List<dynamic> lines = fragment['lines'];

            if (lines.isEmpty || lines[0] is! String) continue;

            final String word = lines[0];

            // Tìm vị trí từ trong content (tính theo ký tự, không phải byte)
            final int matchIndex = content.indexOf(word, lastIndex);
            if (matchIndex == -1) {
              logger.warning("Không tìm thấy từ: $word");
              continue;
            }

            lastIndex = matchIndex + 1;

            final SyncTextData entry = SyncTextData(
              startTime: double.parse(beginStr) * 1000,
              endTime: double.parse(endStr) * 1000,
              text: word,
            );

            transcript.add(entry);
          }

          logger.info(
            'Transcript sync: ${jsonEncode(transcript.map((e) => e.toJson()).toList())}',
          );

          return transcript;
        } catch (e) {
          logger.warning('Không thể phân tích comment JSON: $e');
          return [];
        }
      } else {
        logger.info('Metadata của audio không chứa comment.');
        return [];
      }
    } else {
      final logs = await session.getAllLogsAsString();
      logger.warning(
        'Đọc comment của audio thất bại. Return code: $returnCode. Logs: $logs',
      );
      return [];
    }
  }
}
