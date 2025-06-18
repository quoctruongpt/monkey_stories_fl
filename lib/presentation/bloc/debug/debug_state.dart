part of 'debug_cubit.dart';

class DebugState {
  final bool isModeDebug;
  final bool isShowDebugView;
  final bool isShowLogger;
  final List<Log>? logs;
  final List<HttpLog>? httpLogs;

  DebugState({
    required this.isModeDebug,
    required this.isShowDebugView,
    required this.isShowLogger,
    this.logs,
    this.httpLogs,
  });

  DebugState copyWith({
    bool? isShowDebugView,
    List<Log>? logs,
    bool? isModeDebug,
    bool? isShowLogger,
    List<HttpLog>? httpLogs,
  }) {
    return DebugState(
      isShowDebugView: isShowDebugView ?? this.isShowDebugView,
      logs: logs ?? this.logs,
      isModeDebug: isModeDebug ?? this.isModeDebug,
      isShowLogger: isShowLogger ?? this.isShowLogger,
      httpLogs: httpLogs ?? this.httpLogs,
    );
  }
}
