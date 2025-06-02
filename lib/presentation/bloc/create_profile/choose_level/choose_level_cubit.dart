import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/domain/usecases/tracking/sign_up/ms_select_level.dart';

part 'choose_level_state.dart';

class ChooseLevelTrackingData {
  String source = '';
  MsSelectLevelType level = MsSelectLevelType.none;
  MsSelectLevelClickType clickType = MsSelectLevelClickType.none;
}

class ChooseLevelCubit extends Cubit<ChooseLevelState> {
  final MsSelectLevelTrackingUsecase _msSelectLevelTrackingUsecase;

  final _chooseLevelTrackingData = ChooseLevelTrackingData();

  ChooseLevelCubit({
    required MsSelectLevelTrackingUsecase msSelectLevelTrackingUsecase,
  }) : _msSelectLevelTrackingUsecase = msSelectLevelTrackingUsecase,
       super(const ChooseLevelState());

  void initTrackingData(String source) {
    _chooseLevelTrackingData.source = source;
  }

  void onContinueClicked() {
    _chooseLevelTrackingData.clickType = MsSelectLevelClickType.continueClick;
  }

  void onBackClicked() {
    _chooseLevelTrackingData.clickType = MsSelectLevelClickType.back;
  }

  void trackSelectLevel() {
    _msSelectLevelTrackingUsecase.call(
      MsSelectLevelTrackingParams(
        source: _chooseLevelTrackingData.source,
        level: _chooseLevelTrackingData.level,
        clickType: _chooseLevelTrackingData.clickType,
      ),
    );
  }

  void onPressedLevel(int level) {
    emit(state.copyWith(levelSelected: level));
  }
}
