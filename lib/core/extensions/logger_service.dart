import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/debug.dart';

class Logging {
  // Biến để lưu trữ tham chiếu đến DebugCubit
  static dynamic _debugCubit;

  // Setter để thiết lập DebugCubit từ bên ngoài
  static set debugCubit(dynamic cubit) {
    _debugCubit = cubit;
  }

  static void setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print(
          '${record.level.name}: ${record.time} ${record.loggerName}: ${record.message}',
        );
      }

      // Gửi log đến DebugCubit nếu đã được thiết lập
      if (_debugCubit != null) {
        _debugCubit.addLog(
          Log(
            level: record.level.name,
            time: record.time.toString(),
            name: record.loggerName,
            message: record.message,
          ),
        );
      }
    });
  }
}
