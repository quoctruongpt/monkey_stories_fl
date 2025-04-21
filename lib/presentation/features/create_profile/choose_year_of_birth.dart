import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_year_of_birth/choose_year_of_birth_cubit.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_year_of_birth_view.dart';

class CreateProfileChooseYearOfBirthScreen extends StatelessWidget {
  const CreateProfileChooseYearOfBirthScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChooseYearOfBirthCubit>(),
      child: CreateProfileChooseYOB(name: name),
    );
  }
}

class CreateProfileChooseYOB extends StatelessWidget {
  const CreateProfileChooseYOB({super.key, required this.name});

  final String name;

  void _onPressedContinue(BuildContext context, int year) {
    context.push(
      '${AppRoutePaths.createProfileChooseLevel}?name=$name&yearOfBirth=$year',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseYearOfBirthCubit, ChooseYearOfBirthState>(
      builder: (context, state) {
        return ChooseYearOfBirthView(
          name: name,
          onPressedContinue: (year) => _onPressedContinue(context, year),
          onChangeYear:
              (year) =>
                  context.read<ChooseYearOfBirthCubit>().onChangeYear(year),
          years: state.years ?? [],
          yearSelected: state.yearSelected,
        );
      },
    );
  }
}
