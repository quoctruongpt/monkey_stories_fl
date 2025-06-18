import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/debug.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/features/debugs/http_log.dart';

class Logging {
  // Biến để lưu trữ tham chiếu đến DebugCubit
  static DebugCubit? _debugCubit;

  // Setter để thiết lập DebugCubit từ bên ngoài
  static set debugCubit(DebugCubit? cubit) {
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
        _debugCubit!.addLog(
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

  // --- Methods for Dio Logging ---
  static void logDioResponse(Response response) {
    if (_debugCubit == null) return;

    final startTime =
        response.requestOptions.extra['startTime'] as DateTime? ??
        DateTime.now();
    final endTime = DateTime.now();

    final httpLog = HttpLog(
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      statusCode: response.statusCode ?? 0,
      requestHeaders: response.requestOptions.headers,
      requestBody: response.requestOptions.data,
      responseHeaders: response.headers.map.map(
        (key, value) => MapEntry(key, value.join(', ')),
      ),
      responseBody: response.data,
      timestamp: startTime,
      latency: endTime.difference(startTime),
    );
    _debugCubit!.addHttpLog(httpLog);
  }

  static void logDioError(DioException err) {
    if (_debugCubit == null) return;

    final startTime =
        err.requestOptions.extra['startTime'] as DateTime? ?? DateTime.now();
    final endTime = DateTime.now();
    final httpLog = HttpLog(
      url: err.requestOptions.uri.toString(),
      method: err.requestOptions.method,
      statusCode: err.response?.statusCode ?? 0,
      requestHeaders: err.requestOptions.headers,
      requestBody: err.requestOptions.data,
      responseHeaders:
          err.response?.headers.map.map(
            (key, value) => MapEntry(key, value.join(', ')),
          ) ??
          {},
      responseBody:
          err.response?.data ??
          {'error': err.error.toString(), 'message': err.message},
      timestamp: startTime,
      latency: endTime.difference(startTime),
    );
    _debugCubit!.addHttpLog(httpLog);
  }
}
