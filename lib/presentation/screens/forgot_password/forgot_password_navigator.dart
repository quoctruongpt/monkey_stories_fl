import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/choose_method_fp.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/forgot_password_success.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/input_new_password_fp.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/input_otp_fp.dart';
import 'package:monkey_stories/presentation/screens/forgot_password/input_phone_fp.dart';
import 'package:monkey_stories/presentation/widgets/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';

class ForgotPasswordNavigator extends StatelessWidget {
  const ForgotPasswordNavigator({super.key, required this.child});

  final Widget child;

  void _showOtpBlockDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      imageAsset: 'assets/images/max_1h.png',
      titleText: AppLocalizations.of(context).translate('Thông báo'),
      messageText: AppLocalizations.of(context).translate(
        'Bạn đã thực hiện gửi lại quá 3 lần.\nVui lòng trở lại sau 1 giờ để tiếp tục.',
      ),
      primaryActionText: AppLocalizations.of(context).translate('Tôi đã hiểu'),
      onPrimaryAction: () {
        context.read<ForgotPasswordCubit>().hideOtpBlockDialog();
        context.pop();
      },
      onClose: () {
        context.read<ForgotPasswordCubit>().hideOtpBlockDialog();
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen:
            (previous, current) =>
                previous.isShowOtpBlockDialog != current.isShowOtpBlockDialog,
        listener: (context, state) {
          if (state.isShowOtpBlockDialog) {
            _showOtpBlockDialog(context);
          }
        },
        child: child,
      ),
    );
  }
}

final ShellRoute forgotPasswordRoutes = ShellRoute(
  builder: (context, state, child) => ForgotPasswordNavigator(child: child),
  routes: [
    GoRoute(
      path: AppRoutePaths.chooseMethodFp,
      name: AppRouteNames.chooseMethodFp,
      builder:
          (context, state) => const OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: ChooseMethodFp(),
          ),
    ),
    GoRoute(
      path: AppRoutePaths.inputPhoneFp,
      name: AppRouteNames.inputPhoneFp,
      builder:
          (context, state) => const OrientationWrapper(
            orientation: AppOrientation.portrait,
            child: InputPhoneFp(),
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
