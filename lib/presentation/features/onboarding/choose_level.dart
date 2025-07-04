import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/repositories.dart';
import 'package:monkey_stories/domain/usecases/tracking/sign_up/ms_select_level.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/features/onboarding/obd_navigator.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_level_view.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/onboard_progress.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

class ChooseYearOfBirthOBDTracker {
  DateTime timeStart = DateTime.now();
  MsSelectLevelClickType? clickType;
}

class ChooseLevelOBD extends StatelessWidget {
  ChooseLevelOBD({super.key});

  final ChooseYearOfBirthOBDTracker _chooseYearOfBirthOBDTracker =
      ChooseYearOfBirthOBDTracker();

  void _onContinuePressed(BuildContext context) {
    _chooseYearOfBirthOBDTracker.clickType =
        MsSelectLevelClickType.continueClick;
    context.push(AppRoutePaths.suggestedLevel);
  }

  void _onPressedBack(BuildContext context) {
    _chooseYearOfBirthOBDTracker.clickType = MsSelectLevelClickType.back;
    context.pop();
  }

  void _onTrackPush() {
    _chooseYearOfBirthOBDTracker.timeStart = DateTime.now();
  }

  void _onTrackExit(OnboardingState state) {
    final LevelOnboarding? level = onboardingLevels.firstWhereOrNull(
      (e) => e.id == state.levelId,
    );

    sl<MsSelectLevelTrackingUsecase>().call(
      MsSelectLevelTrackingParams(
        source: 'onboarding',
        level: level?.trackName,
        clickType: _chooseYearOfBirthOBDTracker.clickType,
        haveOccurredError: false,
        errorMessage: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Builder(
          builder: (context) {
            return ScreenTracker(
              routeName: AppRouteNames.chooseLevelOBD,
              observer: obdRouteObserver,
              onTrackPush: _onTrackPush,
              onTrackExit: () => _onTrackExit(state),
              child: Scaffold(
                appBar: AppBarWidget(
                  onBackPressed: () => _onPressedBack(context),
                ),
                body: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: Spacing.md,
                        right: Spacing.md,
                        bottom: Spacing.lg,
                      ),
                      child: Hero(
                        tag: 'onboard_progress',
                        child: OnboardProgress(currentStep: 2, totalSteps: 4),
                      ),
                    ),
                    Expanded(
                      child: ChooseLevelView(
                        onContinuePressed: () => _onContinuePressed(context),
                        levels: onboardingLevels,
                        onPressedLevel: (levelId) {
                          context.read<OnboardingCubit>().onChangeLevel(
                            levelId,
                          );
                        },
                        levelSelected: state.levelId,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
