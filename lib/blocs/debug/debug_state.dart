part of 'debug_cubit.dart';

class DebugState {
  final bool isShowDebugView;

  DebugState({required this.isShowDebugView});

  DebugState copyWith({bool? isShowDebugView}) {
    return DebugState(isShowDebugView: isShowDebugView ?? this.isShowDebugView);
  }
}
