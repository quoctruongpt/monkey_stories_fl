import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/profile.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_level/choose_level_cubit.dart';
import 'package:monkey_stories/presentation/widgets/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';

final logger = Logger('ChooseLevelScreen');

class ChooseLevelScreen extends StatelessWidget {
  const ChooseLevelScreen({
    super.key,
    required this.name,
    required this.yearOfBirth,
  });

  final String name;
  final int yearOfBirth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseLevelCubit(),
      child: ChooseLevelView(name: name, yearOfBirth: yearOfBirth),
    );
  }
}

class ChooseLevelView extends StatelessWidget {
  const ChooseLevelView({
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
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Spacing.md,
          right: Spacing.md,
          bottom: Spacing.xl,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreateProfileHeader(
                      title: AppLocalizations.of(
                        context,
                      ).translate('create_profile.level.title'),
                    ),
                    const SizedBox(height: Spacing.md),
                    BlocBuilder<ChooseLevelCubit, ChooseLevelState>(
                      builder: (context, state) {
                        return Column(
                          children:
                              onboardingLevels.map((e) {
                                final isSelected = state.levelSelected == e.id;

                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: Spacing.sm,
                                  ),
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<ChooseLevelCubit>()
                                          .onPressedLevel(e.id);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.lg,
                                        vertical: Spacing.md,
                                      ),
                                      side: BorderSide(
                                        color:
                                            isSelected
                                                ? AppTheme.primaryColor
                                                : AppTheme
                                                    .buttonPrimaryDisabledBackground,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        DifficultyLevel(
                                          difficulty: e.difficulty,
                                        ),
                                        const SizedBox(width: Spacing.lg),
                                        Flexible(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            ).translate(e.description),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              color:
                                                  isSelected
                                                      ? AppTheme.primaryColor
                                                      : AppTheme.textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<ChooseLevelCubit, ChooseLevelState>(
              builder: (context, state) {
                return AppButton.primary(
                  text: AppLocalizations.of(
                    context,
                  ).translate('create_profile.level.act'),
                  onPressed: () => _onContinuePressed(context),
                  disabled: state.levelSelected == null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyLevel extends StatelessWidget {
  const DifficultyLevel({super.key, required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 10,
          decoration: BoxDecoration(
            color:
                difficulty >= 3
                    ? AppTheme.primaryColor
                    : AppTheme.skyLightColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Container(
          width: 28,
          height: 10,
          decoration: BoxDecoration(
            color:
                difficulty >= 2
                    ? AppTheme.primaryColor
                    : AppTheme.skyLightColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Container(
          width: 28,
          height: 10,
          decoration: BoxDecoration(
            color:
                difficulty >= 1
                    ? AppTheme.primaryColor
                    : AppTheme.skyLightColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
