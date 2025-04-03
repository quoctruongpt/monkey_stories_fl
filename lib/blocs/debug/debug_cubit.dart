import 'package:flutter_bloc/flutter_bloc.dart';

part 'debug_state.dart';

class DebugCubit extends Cubit<DebugState> {
  DebugCubit() : super(DebugState(isShowDebugView: false));

  void toggleDebugView() {
    emit(state.copyWith(isShowDebugView: !state.isShowDebugView));
  }
}
