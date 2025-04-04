import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monkey_stories/models/debug.dart';

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

  void clearLogs() {
    emit(state.copyWith(logs: []));
  }

  void toggleModeDebug() {
    emit(state.copyWith(isModeDebug: !state.isModeDebug));
  }

  void toggleLogger() {
    emit(state.copyWith(isShowLogger: !state.isShowLogger));
  }
}
