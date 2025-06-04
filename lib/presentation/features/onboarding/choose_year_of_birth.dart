import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_year_of_birth_view.dart';

class ChooseYearOfBirthOBD extends StatelessWidget {
  const ChooseYearOfBirthOBD({super.key});

  void _onPressedContinue(BuildContext context) {
    context.push(AppRoutePaths.chooseLevelOBD);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return state.name?.isNotEmpty ?? false
            ? ChooseYearOfBirthView(
              name: state.name ?? '',
              onPressedContinue: (year) => _onPressedContinue(context),
              onChangeYear: context.read<OnboardingCubit>().onChangeYear,
              years: state.years,
              yearSelected: state.yearSelected,
            )
            : const SizedBox.shrink();
      },
    );
  }
}
