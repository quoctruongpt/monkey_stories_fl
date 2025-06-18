import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void handleContinue() {
      if (context.read<ProfileCubit>().state.profiles.isEmpty) {
        context.pushNamed(
          AppRouteNames.createProfileInputName,
          queryParameters: {'source': 'sign_up'},
        );
      } else {
        context.push(AppRoutePaths.home);
      }
    }

    return Scaffold(
      body: SuccessScreen(
        title: AppLocalizations.of(context).translate('sign_up_success.title'),
        onPressed: handleContinue,
      ),
    );
  }
}
