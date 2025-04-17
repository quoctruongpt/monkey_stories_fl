import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

final logger = Logger('ForgotPasswordSuccessScreen');

class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key});

  void _onContinue(BuildContext context) {
    final method = context.read<ForgotPasswordCubit>().state.method;
    final formValues = context.read<ForgotPasswordCubit>().state.formValues;

    final uri = Uri(
      path: AppRoutePaths.login,
      queryParameters: {
        'username':
            method == ForgotPasswordType.phone
                ? formValues.phone
                : formValues.email,
        'password': formValues.password,
      },
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SuccessScreen(
        title: AppLocalizations.of(
          context,
        ).translate('Cập nhật mật khẩu thành công'),
        onPressed: () => _onContinue(context),
      ),
    );
  }
}
