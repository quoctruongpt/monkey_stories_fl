import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_level/choose_level_cubit.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_level_view.dart';

final logger = Logger('ChooseLevelScreen');

class ChooseLevelScreen extends StatelessWidget {
  const ChooseLevelScreen({
    super.key,
    required this.name,
    required this.yearOfBirth,
  });

  final String name;
  final int yearOfBirth;

  void _onContinuePressed(BuildContext context) {
    final uri = Uri(
      path: AppRoutePaths.createProfileLoading,
      queryParameters: {
        'name': name,
        'yearOfBirth': yearOfBirth.toString(),
        'levelId':
            context.read<ChooseLevelCubit>().state.levelSelected.toString(),
      },
    );

    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseLevelCubit(),
      child: BlocBuilder<ChooseLevelCubit, ChooseLevelState>(
        builder: (context, state) {
          return ChooseLevelView(
            onContinuePressed: () => _onContinuePressed(context),
            levels: onboardingLevels,
            levelSelected: state.levelSelected,
            onPressedLevel: (levelId) {
              context.read<ChooseLevelCubit>().onPressedLevel(levelId);
            },
          );
        },
      ),
    );
  }
}
