// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/domain/usecases/tracking/onboarding/ms_ob_view_personalize_loading_screen.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/create_profile_loading_view.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

class OnboardLoading extends StatefulWidget {
  const OnboardLoading({super.key});

  @override
  State<OnboardLoading> createState() => _OnboardLoadingState();
}

class _OnboardLoadingState extends State<OnboardLoading> {
  DateTime timeStart = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().onStart();
    });
  }

  void _onTrackPush() {
    timeStart = DateTime.now();
  }

  void _onTrackExit() {
    sl<MsObViewPersonalizeLoadingScreenTrackingUsecase>().call(
      MsObViewPersonalizeLoadingScreenParams(
        timeOnScreen: DateTime.now().difference(timeStart).inSeconds,
      ),
    );
  }

  void _onError(OnboardingError error) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.onboarding.error.title'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.onboarding.error.desc'),
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.onboarding.error.act'),
      onPrimaryAction: () {
        if (error.onboardingProgress == OnboardingProgress.init) {
          context.go(AppRoutePaths.intro);
        } else {
          context.go(AppRoutePaths.home);
        }
      },
      isCloseable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTracker(
      routeName: AppRouteNames.onboardLoading,
      onTrackPush: _onTrackPush,
      onTrackExit: _onTrackExit,
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) {
          return previous.error != current.error && current.error != null;
        },
        listener: (context, state) {
          _onError(state.error!);
        },
        child: BlocListener<OnboardingCubit, OnboardingState>(
          listenWhen:
              (previous, current) => previous.progress != current.progress,
          listener: (context, state) {
            if (state.progress == 1) {
              context.go(AppRoutePaths.obdPurchase);
            }
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return CreateProfileLoadingView(progress: state.progress);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
