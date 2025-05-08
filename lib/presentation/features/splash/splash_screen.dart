import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/bloc/splash/splash_cubit.dart';
import 'package:monkey_stories/presentation/bloc/splash/splash_state.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

// Đổi tên class thành SplashScreen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _onSplashError(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: 'Lỗi',
      messageText: 'Không thể kết nối',
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: 'OK',
    );
  }

  void _handleListener(BuildContext context, SplashState state) {
    switch (state) {
      case SplashAuthenticated():
        GoRouter.of(context).replace(AppRoutePaths.home);
        return;
      case SplashUnauthenticated():
        GoRouter.of(context).replace(AppRoutePaths.intro);
        return;
      case SplashNeedCreateAccount():
        showCustomNoticeDialog(
          context: context,
          titleText: AppLocalizations.of(
            context,
          ).translate('app.obd_payment.created_account.title'),
          messageText: AppLocalizations.of(
            context,
          ).translate('app.obd_payment.created_account.desc'),
          imageAsset: 'assets/images/max_warning.png',
          primaryActionText: AppLocalizations.of(
            context,
          ).translate('app.obd_payment.created_account.act'),
          onPrimaryAction: () {
            context.read<UserCubit>().togglePurchasing();
            context.replace(AppRoutePaths.signUp);
          },
          isCloseable: false,
        );
        return;
      case SplashAuthenticatedBefore():
        GoRouter.of(context).replace(AppRoutePaths.login);
        return;
      case SplashError():
        _onSplashError(context);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..runApp(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: _handleListener,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return Text('Device: ${state.deviceId}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
