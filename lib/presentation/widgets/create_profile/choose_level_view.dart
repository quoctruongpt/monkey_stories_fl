import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_footer.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';

class ChooseLevelView extends StatelessWidget {
  const ChooseLevelView({
    super.key,
    required this.onContinuePressed,
    required this.levels,
    this.levelSelected,
    required this.onPressedLevel,
  });

  final VoidCallback onContinuePressed;
  final List<LevelOnboarding> levels;
  final int? levelSelected;
  final void Function(int levelId) onPressedLevel;

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
                    Column(
                      children:
                          levels.map((e) {
                            final isSelected = levelSelected == e.id;

                            return Container(
                              margin: const EdgeInsets.only(bottom: Spacing.sm),
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  onPressedLevel(e.id);
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
                                    DifficultyLevel(difficulty: e.difficulty),
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
                    ),

                    const CreateProfileFooter(),
                  ],
                ),
              ),
            ),

            AppButton.primary(
              text: AppLocalizations.of(
                context,
              ).translate('create_profile.level.act'),
              onPressed: onContinuePressed,
              disabled: levelSelected == null,
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
