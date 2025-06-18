import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/features/forgot_password/forgot_password_navigator.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:monkey_stories/presentation/widgets/base/horizontal_line_text.dart';

class ChooseMethodFp extends StatefulWidget {
  const ChooseMethodFp({super.key, this.isFromChangePassword = false});

  final bool? isFromChangePassword;

  @override
  State<ChooseMethodFp> createState() => _ChooseMethodFpState();
}

class _ChooseMethodFpState extends State<ChooseMethodFp>
    with RouteAware, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    forgotPasswordRouteObserver.subscribe(this, route as PageRoute);
  }

  @override
  void didPush() {
    context.read<ForgotPasswordCubit>().onStartChooseMethod();
  }

  @override
  void didPopNext() {
    context.read<ForgotPasswordCubit>().onStartChooseMethod();
  }

  @override
  void didPop() {
    context.read<ForgotPasswordCubit>().onChooseMethodBack();
    context.read<ForgotPasswordCubit>().trackChooseMethod();
  }

  @override
  void didPushNext() {
    context.read<ForgotPasswordCubit>().onEndChooseMethod();
    context.read<ForgotPasswordCubit>().trackChooseMethod();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        ModalRoute.of(context)?.settings.name == AppRouteNames.chooseMethodFp) {
      context.read<ForgotPasswordCubit>().onEndChooseMethod();
      context.read<ForgotPasswordCubit>().trackChooseMethod();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    forgotPasswordRouteObserver.unsubscribe(this);
    super.dispose();
  }

  void _onPressed(BuildContext context, ForgotPasswordType method) {
    context.read<ForgotPasswordCubit>().chooseMethod(method);
    context.pushNamed(
      AppRouteNames.inputPhoneFp,
      queryParameters: {
        'isFromChangePassword': widget.isFromChangePassword.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Column(
          children: [
            ForgotPasswordHeader(
              description: AppLocalizations.of(
                context,
              ).translate('app.forgot_password.choose_method'),
            ),

            FilledButton(
              onPressed:
                  widget.isFromChangePassword == true &&
                          context
                                  .read<UserCubit>()
                                  .state
                                  .user
                                  ?.phoneInfo
                                  ?.phone
                                  .isEmpty ==
                              true
                      ? null
                      : () => _onPressed(context, ForgotPasswordType.phone),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.successColor,
              ),
              child: ContentButton(
                text: AppLocalizations.of(
                  context,
                ).translate('app.forgot_password.sms'),
                icon: Icons.phone,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: HorizontalLineText(
                text: AppLocalizations.of(
                  context,
                ).translate('app.forgot_password.or'),
              ),
            ),

            OutlinedButton(
              onPressed:
                  widget.isFromChangePassword == true &&
                          context
                                  .read<UserCubit>()
                                  .state
                                  .user
                                  ?.email
                                  ?.isEmpty ==
                              true
                      ? null
                      : () => _onPressed(context, ForgotPasswordType.email),
              child: ContentButton(
                text: AppLocalizations.of(
                  context,
                ).translate('app.forgot_password.email'),
                icon: Icons.email,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentButton extends StatelessWidget {
  const ContentButton({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: Spacing.sm),
              Text(text),
            ],
          ),
        ),
        const Icon(Icons.navigate_next, size: 24),
      ],
    );
  }
}
