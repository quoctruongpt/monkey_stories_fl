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
import 'package:permission_handler/permission_handler.dart';

// Đổi tên class thành SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _scaleAnimation;
  late AnimationController
  _detailsAnimationController; // Controller cho details
  late Animation<double> _detailsScaleAnimation; // Animation cho details

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(
        seconds: 60,
      ), // Tốc độ xoay, ví dụ 10 giây một vòng
      vsync: this,
    )..repeat(); // Lặp lại animation

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Thời gian hiệu ứng pop
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut, // Kiểu hiệu ứng "pop"
      ),
    );

    // Khởi tạo controller và animation cho details
    _detailsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Thời gian pop cho details
      vsync: this,
    );

    _detailsScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _detailsAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _detailsAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _logoAnimationController.dispose(); // Hủy controller của logo
    _detailsAnimationController.dispose(); // Hủy details controller
    super.dispose();
  }

  void _onSplashError(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.active_license.error'),
      messageText: AppLocalizations.of(context).translate('error'),
      imageAsset: 'assets/images/monkey_sad.png',
    );
  }

  void _handleListener(BuildContext context, SplashState state) {
    Permission.notification.request();
    switch (state) {
      case SplashAuthenticated():
        GoRouter.of(context).replace(AppRoutePaths.listProfile);
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
          body: SafeArea(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: Image.asset(
                        'assets/images/bg_splash.png',
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation, // Áp dụng scale animation
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 243,
                        height: 198,
                      ),
                    ),

                    Positioned(
                      top: 30,
                      right: 20,
                      child: ScaleTransition(
                        scale: _detailsScaleAnimation,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/mom_choice.png',
                              width: 51,
                              height: 49,
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              'assets/images/kid_safe.png',
                              width: 100,
                              height: 46,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return ScaleTransition(
                      scale:
                          _detailsScaleAnimation, // Sử dụng animation cho details
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          'Device: ${state.deviceId}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFAFAFAF),
                          ),
                        ),
                      ),
                    );
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
