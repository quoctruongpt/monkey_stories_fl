import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/features/forgot_password/choose_method_fp.dart';
import 'package:monkey_stories/presentation/features/forgot_password/forgot_password_success.dart';
import 'package:monkey_stories/presentation/features/forgot_password/input_new_password_fp.dart';
import 'package:monkey_stories/presentation/features/forgot_password/input_otp_fp.dart';
import 'package:monkey_stories/presentation/features/forgot_password/input_phone_fp.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';

class ForgotPasswordNavigator extends StatefulWidget {
  const ForgotPasswordNavigator({super.key, required this.child});

  final Widget child;

  @override
  State<ForgotPasswordNavigator> createState() =>
      _ForgotPasswordNavigatorState();
}

class _ForgotPasswordNavigatorState extends State<ForgotPasswordNavigator>
    with RouteAware {
  late final ForgotPasswordCubit _forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = sl<ForgotPasswordCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    routeObserver.subscribe(this, route as PageRoute);
  }

  @override
  void didPop() {
    _forgotPasswordCubit.onEndChooseMethod();
    _forgotPasswordCubit.trackChooseMethod();
  }

  @override
  void dispose() {
    forgotPasswordRouteObserver.unsubscribe(this);
    super.dispose();
  }

  void _showOtpBlockDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      imageAsset: 'assets/images/max_1h.png',
      titleText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.notice'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.otp_block_dialog'),
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.i_understand'),
      onPrimaryAction: () {
        _forgotPasswordCubit.hideOtpBlockDialog();
        context.pop();
      },
      onClose: () {
        _forgotPasswordCubit.hideOtpBlockDialog();
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider.value(
        value: _forgotPasswordCubit,
        child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listenWhen:
              (previous, current) =>
                  previous.isShowOtpBlockDialog != current.isShowOtpBlockDialog,
          listener: (context, state) {
            if (state.isShowOtpBlockDialog) {
              _showOtpBlockDialog(context);
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}

final RouteObserver<PageRoute> forgotPasswordRouteObserver =
    RouteObserver<PageRoute>();

final ShellRoute forgotPasswordRoutes = ShellRoute(
  builder: (context, state, child) => ForgotPasswordNavigator(child: child),
  observers: [forgotPasswordRouteObserver],
  routes: [
    GoRoute(
      path: AppRoutePaths.chooseMethodFp,
      name: AppRouteNames.chooseMethodFp,
      builder: (context, state) {
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ChooseMethodFp(
            isFromChangePassword:
                state.uri.queryParameters['isFromChangePassword'] == 'true',
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.inputPhoneFp,
      name: AppRouteNames.inputPhoneFp,
      builder:
          (context, state) => OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: InputPhoneFp(
              isFromChangePassword:
                  state.uri.queryParameters['isFromChangePassword'] == 'true',
            ),
          ),
    ),
    GoRoute(
      path: AppRoutePaths.inputOtpFp,
      name: AppRouteNames.inputOtpFp,
      builder:
          (context, state) => const OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: InputOtpFp(),
          ),
    ),
    GoRoute(
      path: AppRoutePaths.inputNewPasswordFp,
      name: AppRouteNames.inputNewPasswordFp,
      builder:
          (context, state) => const OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: InputNewPasswordFp(),
          ),
    ),
    GoRoute(
      path: AppRoutePaths.forgotPasswordSuccess,
      name: AppRouteNames.forgotPasswordSuccess,
      builder:
          (context, state) => const OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: ForgotPasswordSuccessScreen(),
          ),
    ),
  ],
);
