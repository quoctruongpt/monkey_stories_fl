import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/domain/usecases/tracking/onboarding/ms_ob_age.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/features/onboarding/obd_navigator.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_year_of_birth_view.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/onboard_progress.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

class ChooseYearOfBirthOBDTracker {
  DateTime timeStart = DateTime.now();
  ClickType? clickType;
}

class ChooseYearOfBirthOBD extends StatelessWidget {
  ChooseYearOfBirthOBD({super.key});

  final String source = 'onboarding';
  final ChooseYearOfBirthOBDTracker _chooseYearOfBirthOBDTracker =
      ChooseYearOfBirthOBDTracker();

  void _onPressedContinue(BuildContext context) {
    _chooseYearOfBirthOBDTracker.clickType = ClickType.continued;
    context.push(AppRoutePaths.chooseLevelOBD);
  }

  void _onPressedBack(BuildContext context) {
    _chooseYearOfBirthOBDTracker.clickType = ClickType.back;
    context.pop();
  }

  void _onTrackPush() {
    _chooseYearOfBirthOBDTracker.timeStart = DateTime.now();
  }

  void _onTrackExit(OnboardingState state) {
    sl<MsObAgeTrackingUsecase>().call(
      MsObAgeParams(
        source: source,
        yob: state.yearSelected ?? 0,
        clickType: _chooseYearOfBirthOBDTracker.clickType,
        timeOnScreen:
            DateTime.now()
                .difference(_chooseYearOfBirthOBDTracker.timeStart)
                .inSeconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return ScreenTracker(
          routeName: AppRouteNames.chooseYearOfBirthOBD,
          observer: obdRouteObserver,
          onTrackPush: _onTrackPush,
          onTrackExit: () => _onTrackExit(state),
          child: Scaffold(
            appBar: AppBarWidget(onBackPressed: () => _onPressedBack(context)),
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
                    child: OnboardProgress(currentStep: 1, totalSteps: 4),
                  ),
                ),
                state.name?.isNotEmpty ?? false
                    ? ChooseYearOfBirthView(
                      name: state.name ?? '',
                      onPressedContinue: (year) => _onPressedContinue(context),
                      onChangeYear:
                          context.read<OnboardingCubit>().onChangeYear,
                      years: state.years,
                      yearSelected: state.yearSelected,
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
