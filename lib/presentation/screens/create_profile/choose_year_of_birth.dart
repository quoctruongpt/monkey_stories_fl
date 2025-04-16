import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_year_of_birth/choose_year_of_birth_cubit.dart';
import 'package:monkey_stories/presentation/widgets/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';

class CreateProfileChooseYearOfBirthScreen extends StatelessWidget {
  const CreateProfileChooseYearOfBirthScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChooseYearOfBirthCubit>(),
      child: ChooseYearOfBirthView(name: name),
    );
  }
}

class ChooseYearOfBirthView extends StatelessWidget {
  const ChooseYearOfBirthView({super.key, required this.name});

  final String name;

  void _onPressedContinue(BuildContext context) {
    context.push(
      '${AppRoutePaths.createProfileChooseLevel}?name=$name&yearOfBirth=${context.read<ChooseYearOfBirthCubit>().state.yearSelected}',
    );
  }

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
                    CreateProfileHeader(title: '$name sinh vào năm nào?'),
                    const SizedBox(height: Spacing.md),
                    BlocBuilder<ChooseYearOfBirthCubit, ChooseYearOfBirthState>(
                      builder: (context, state) {
                        final years = state.years ?? [];

                        return Column(
                          children: [
                            GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.3,
                              children: List.generate(
                                12,
                                (index) => _buildYearButton(
                                  context,
                                  years[index],
                                  state.yearSelected == years[index],
                                  () => context
                                      .read<ChooseYearOfBirthCubit>()
                                      .onChangeYear(years[index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final buttonWidth =
                                    (constraints.maxWidth - (12 * 3)) / 4;
                                final buttonHeight = buttonWidth / 1.3;

                                return SizedBox(
                                  width: double.infinity,
                                  height: buttonHeight,
                                  child: _buildYearButton(
                                    context,
                                    years[12],
                                    state.yearSelected == years[12],
                                    () => context
                                        .read<ChooseYearOfBirthCubit>()
                                        .onChangeYear(years[12]),
                                    customText: 'Sinh trước năm ${years[12]}',
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              BlocBuilder<ChooseYearOfBirthCubit, ChooseYearOfBirthState>(
                builder: (context, state) {
                  return AppButton.primary(
                    text: "Tiếp tục",
                    onPressed: () => _onPressedContinue(context),
                    disabled: state.yearSelected == null,
                  );
                },
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
        backgroundColor:
            isSelected ? AppTheme.blueLightColor : Colors.transparent,
      ),
      child: Text(
        customText ?? year.toString(),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color:
              isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
        ),
      ),
    );
  }
}
