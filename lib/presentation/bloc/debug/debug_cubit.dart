// Package imports:
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Project imports:
import 'package:monkey_stories/core/constants/debug.dart';
import 'package:monkey_stories/core/extensions/logger_service.dart';
import 'package:monkey_stories/presentation/features/debugs/http_log.dart';

part 'debug_state.dart';

class DebugCubit extends HydratedCubit<DebugState> {
  DebugCubit()
    : super(
        DebugState(
          isShowDebugView: false,
          logs: [],
          isModeDebug: false,
          isShowLogger: false,
        ),
      );

  @override
  Map<String, dynamic> toJson(DebugState state) {
    if (state.isShowLogger) {
      Logging.debugCubit = this;
    }

    return {
      'isModeDebug': state.isModeDebug,
      'isShowLogger': state.isShowLogger,
    };
  }

  @override
  DebugState? fromJson(Map<String, dynamic> json) {
    return DebugState(
      isShowDebugView: false,
      isModeDebug: json['isModeDebug'] as bool,
      isShowLogger: json['isShowLogger'] as bool,
    );
  }

  void toggleDebugView() {
    emit(state.copyWith(isShowDebugView: !state.isShowDebugView));
  }

  void addLog(Log log) {
    emit(state.copyWith(logs: [...state.logs ?? [], log]));
  }

  void addHttpLog(HttpLog log) {
    emit(state.copyWith(httpLogs: [...state.httpLogs ?? [], log]));
  }

  void clearLogs() {
    emit(state.copyWith(logs: [], httpLogs: []));
  }

  void toggleModeDebug() {
    emit(state.copyWith(isModeDebug: !state.isModeDebug));
  }

  void toggleLogger() {
    emit(state.copyWith(isShowLogger: !state.isShowLogger));
  }
}
