import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/entities/report/report_entity.dart';
import 'package:monkey_stories/domain/usecases/report/get_report_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_screen.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_stories_level.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_phonics.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_rc.dart';

part 'report_state.dart';

final logger = Logger('ReportCubit');

class ReportTracker {
  DateTime? startTime;
  bool hasClickedSwitchProfile = false;
}

class ReportCubit extends Cubit<ReportState> {
  final ProfileCubit _profileCubit;
  final UserCubit _userCubit;
  final GetReportUsecase _getReportUsecase;
  final MsLearningReportScreenTrackingUsecase
  _msLearningReportScreenTrackingUsecase;
  final MsLearningReportStoriesLevelTrackingUsecase
  _msLearningReportStoriesLevelTrackingUsecase;
  final MsLearningReportPhonicsTrackingUsecase
  _msLearningReportPhonicsTrackingUsecase;
  final MsLearningReportRCTrackingUsecase _msLearningReportRCTrackingUsecase;

  final ReportTracker _reportTracker = ReportTracker();

  ReportCubit({
    required ProfileCubit profileCubit,
    required GetReportUsecase getReportUsecase,
    required UserCubit userCubit,
    required MsLearningReportScreenTrackingUsecase
    msLearningReportScreenTrackingUsecase,
    required MsLearningReportStoriesLevelTrackingUsecase
    msLearningReportStoriesLevelTrackingUsecase,
    required MsLearningReportPhonicsTrackingUsecase
    msLearningReportPhonicsTrackingUsecase,
    required MsLearningReportRCTrackingUsecase
    msLearningReportRCTrackingUsecase,
  }) : _profileCubit = profileCubit,
       _userCubit = userCubit,
       _getReportUsecase = getReportUsecase,
       _msLearningReportScreenTrackingUsecase =
           msLearningReportScreenTrackingUsecase,
       _msLearningReportStoriesLevelTrackingUsecase =
           msLearningReportStoriesLevelTrackingUsecase,
       _msLearningReportPhonicsTrackingUsecase =
           msLearningReportPhonicsTrackingUsecase,
       _msLearningReportRCTrackingUsecase = msLearningReportRCTrackingUsecase,
       super(const ReportState()) {
    init();
  }

  Future<void> init() async {
    ProfileEntity? profile = _profileCubit.state.currentProfile;
    profile ??= _profileCubit.state.profiles.first;
    onProfileChanged(profile);
  }

  Future<void> onProfileChanged(ProfileEntity profile) async {
    emit(state.copyWith(currentProfile: profile));
    getReport();
  }

  Future<void> getReport() async {
    try {
      emit(state.copyWith(isLoading: true, hasError: false, clearData: true));
      final result = await _getReportUsecase.call(
        GetReportParams(
          userId: _userCubit.state.user?.userId ?? 0,
          profileId: state.currentProfile?.id ?? 0,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(hasError: true, errorMessage: failure.message));
        },
        (data) {
          emit(state.copyWith(data: data));
        },
      );
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(hasError: true, errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void startTracking() {
    _reportTracker.startTime = DateTime.now();
  }

  void trackSwitchProfile() {
    _reportTracker.hasClickedSwitchProfile = true;
  }

  void trackExit() {
    _msLearningReportScreenTrackingUsecase.call(
      MsLearningReportScreenParams(
        profileId: state.currentProfile?.id ?? 0,
        timeOnScreen:
            DateTime.now().difference(_reportTracker.startTime!).inSeconds,
        hasOccurredError: state.hasError,
        errorMessage: state.errorMessage,
        hasClickedSwitchProfile: _reportTracker.hasClickedSwitchProfile,
      ),
    );
  }

  void trackStoriesLevel(int index) {
    _msLearningReportStoriesLevelTrackingUsecase.call(
      MsLearningReportStoriesLevelParams(
        profileId: state.currentProfile?.id ?? 0,
        timeOnScreen:
            DateTime.now().difference(_reportTracker.startTime!).inSeconds,
        hasOccurredError: false,
        clickType:
            index == 0
                ? StoriesLevelClickType.thisWeek
                : StoriesLevelClickType.thisMonth,
      ),
    );
  }

  void trackPhonics(PhonicsClickType clickType) {
    _msLearningReportPhonicsTrackingUsecase.call(
      MsLearningReportPhonicsParams(
        profileId: state.currentProfile?.id ?? 0,
        timeOnScreen:
            DateTime.now().difference(_reportTracker.startTime!).inSeconds,
        hasOccurredError: false,
        clickType: clickType,
      ),
    );
  }

  void trackRC(RCClickType clickType) {
    _msLearningReportRCTrackingUsecase.call(
      MsLearningReportRCParams(
        profileId: state.currentProfile?.id ?? 0,
        timeOnScreen:
            DateTime.now().difference(_reportTracker.startTime!).inSeconds,
        hasOccurredError: false,
        clickType: clickType,
      ),
    );
  }

  @override
  void emit(ReportState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }
}
