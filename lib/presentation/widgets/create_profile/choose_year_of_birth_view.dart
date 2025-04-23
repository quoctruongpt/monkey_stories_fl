import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_footer.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';

class ChooseYearOfBirthView extends StatelessWidget {
  const ChooseYearOfBirthView({
    super.key,
    required this.name,
    required this.onPressedContinue,
    this.yearSelected,
    required this.onChangeYear,
    required this.years,
  });

  final String name;
  final void Function(int year) onPressedContinue;
  final int? yearSelected;
  final void Function(int year) onChangeYear;
  final List<int> years;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            bottom: Spacing.xl,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CreateProfileHeader(
                      title: AppLocalizations.of(context).translate(
                        'create_profile.year_of_birth.title',
                        params: {'Name': name},
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const crossAxisCount = 4;
                        const spacing = Spacing.sm;
                        final totalSpacing = spacing * (crossAxisCount - 1);
                        final itemWidth =
                            (constraints.maxWidth - totalSpacing) /
                            crossAxisCount;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: List.generate(
                            12,
                            (index) => SizedBox(
                              width: itemWidth,
                              child: _buildYearButton(
                                context,
                                years[index],
                                yearSelected == years[index],
                                () => onChangeYear(years[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: _buildYearButton(
                        context,
                        years[12],
                        yearSelected == years[12],
                        () => onChangeYear(years[12]),
                        customText: AppLocalizations.of(context).translate(
                          'year.before',
                          params: {'year': years[12].toString()},
                        ),
                      ),
                    ),

                    const CreateProfileFooter(),
                  ],
                ),
              ),

              AppButton.primary(
                text: AppLocalizations.of(
                  context,
                ).translate('create_profile.year_of_birth.act'),
                onPressed: () => onPressedContinue(yearSelected!),
                disabled: yearSelected == null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearButton(
    BuildContext context,
    int year,
    bool isSelected,
    VoidCallback onPressed, {
    String? customText,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color:
              isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.buttonPrimaryDisabledBackground,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.md,
        ),
        backgroundColor:
            isSelected ? AppTheme.blueLightColor : Colors.transparent,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          customText ?? year.toString(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color:
                isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
