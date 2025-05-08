import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_level_view.dart';

class ChooseLevelOBD extends StatelessWidget {
  const ChooseLevelOBD({super.key});

  void _onContinuePressed(BuildContext context) {
    context.push(AppRoutePaths.suggestedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return ChooseLevelView(
          onContinuePressed: () => _onContinuePressed(context),
          levels: onboardingLevels,
          onPressedLevel: (levelId) {
            context.read<OnboardingCubit>().onChangeLevel(levelId);
          },
          levelSelected: state.levelId,
        );
      },
    );
  }
}
