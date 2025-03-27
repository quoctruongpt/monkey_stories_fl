import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class Logging {
  static void setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print(
          '${record.level.name}: ${record.time} ${record.loggerName}: ${record.message}',
        );
      }
    });
  }
}
