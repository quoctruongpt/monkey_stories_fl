import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/di/injection_container.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..runApp(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            // Navigate to Home and replace splash route
            GoRouter.of(context).replace(AppRoutePaths.obdPurchase);
          } else if (state is SplashUnauthenticated) {
            // Navigate to Login and replace splash route
            GoRouter.of(context).replace(AppRoutePaths.intro);
          } else if (state is SplashError) {
            // Optionally show an error message
            _onSplashError(context);
          }
        },
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
