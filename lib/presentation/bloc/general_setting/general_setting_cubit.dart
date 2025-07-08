// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:monkey_stories/domain/usecases/tracking/setting/ms_general_setting_detail.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';

part 'general_setting_state.dart';

class GeneralSettingTracker {
  DateTime? startTime;
  bool hasClickedLanguage = false;
  bool hasClickedBack = false;
  bool hasClickedNotification = false;
  bool hasClickedBackgroundMusic = false;
}

class GeneralSettingCubit extends Cubit<GeneralSettingState> {
  final AppCubit _appCubit;
  final MsGeneralSettingDetailTrackingUsecase
  _msGeneralSettingDetailTrackingUsecase;

  final GeneralSettingTracker _generalSettingTracker = GeneralSettingTracker();

  GeneralSettingCubit({
    required AppCubit appCubit,
    required MsGeneralSettingDetailTrackingUsecase
    msGeneralSettingDetailTrackingUsecase,
  }) : _appCubit = appCubit,
       _msGeneralSettingDetailTrackingUsecase =
           msGeneralSettingDetailTrackingUsecase,
       super(const GeneralSettingState());

  void changeLanguage(String language) {
    _generalSettingTracker.hasClickedLanguage = true;
    _appCubit.changeLanguage(language);
  }

  void toggleNotification() {
    _generalSettingTracker.hasClickedNotification = true;
    _appCubit.toggleNotification();
  }

  void toggleBackgroundMusic() {
    _generalSettingTracker.hasClickedBackgroundMusic = true;
    _appCubit.toggleBackgroundMusic();
  }

  void trackBack() {
    _generalSettingTracker.hasClickedBack = true;
  }

  void startTracking() {
    _generalSettingTracker.startTime = DateTime.now();
  }

  void trackGeneralSetting() {
    _msGeneralSettingDetailTrackingUsecase.call(
      MsGeneralSettingDetailParams(
        enableNotification: _appCubit.state.isNotificationEnabled,
        timeOnScreen:
            DateTime.now()
                .difference(_generalSettingTracker.startTime!)
                .inSeconds,
        hasClickedLanguage: _generalSettingTracker.hasClickedLanguage,
        hasClickedBack: _generalSettingTracker.hasClickedBack,
        hasClickedNotification: _generalSettingTracker.hasClickedNotification,
        hasClickedBackgroundMusic:
            _generalSettingTracker.hasClickedBackgroundMusic,
        hasOccurredError: false,
        errorMessage: null,
      ),
    );
  }
}
