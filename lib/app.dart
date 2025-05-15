import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/bloc/float_button/float_button_cubit.dart';
import 'package:monkey_stories/core/localization/app_localizations_delegate.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/widgets/unity/unity_widget.dart';
import 'package:monkey_stories/presentation/features/debugs/debug_navigator.dart';
import 'package:monkey_stories/core/extensions/logger_service.dart';
import 'package:monkey_stories/presentation/widgets/loading/orientation_loading_widget.dart';
import 'package:monkey_stories/presentation/widgets/leave_contact_dialog/leave_contact_dialog.dart';
import 'package:monkey_stories/presentation/bloc/dialog/dialog_cubit.dart';

final logger = Logger('MyApp');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<UnityCubit>()),
        BlocProvider(create: (_) => sl<AppCubit>()),
        BlocProvider(create: (_) => sl<DebugCubit>()),
        BlocProvider(create: (_) => sl<FloatButtonCubit>()),
        BlocProvider(create: (_) => sl<UserCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..getCurrentProfile()),
        BlocProvider(create: (_) => sl<PurchasedCubit>()),
        BlocProvider(create: (_) => DialogCubit()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen:
            (previous, current) =>
                previous.languageCode != current.languageCode,
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Languages.getSupportedLocales(),
            locale: Locale(state.languageCode),
            builder: (context, child) {
              return AppBuilder(child: child);
            },
          );
        },
      ),
    );
  }
}

class AppBuilder extends StatefulWidget {
  final Widget? child;
  const AppBuilder({super.key, this.child});

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad,
    );

    _animationController.addListener(_updateButtonPosition);

    // Lắng nghe thay đổi trạng thái của DebugCubit để bật/tắt logging
    context.read<DebugCubit>().stream.listen((state) {
      if (state.isShowLogger) {
        Logging.debugCubit = context.read<DebugCubit>();
      } else {
        Logging.debugCubit = null;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateButtonPosition() {
    context.read<FloatButtonCubit>().updateAnimationProgress(_animation.value);

    if (_animation.value >= 1.0) {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Hiển thị nội dung chính của ứng dụng
        widget.child ?? const SizedBox.shrink(),

        // Unity Widget sẽ đè lên UI khi cần thiết
        BlocBuilder<UnityCubit, UnityState>(
          buildWhen: (previous, current) {
            logger.info(
              'Unity state change: ${current.isUnityVisible} ${previous.isUnityVisible}',
            );
            return previous.isUnityVisible != current.isUnityVisible;
          },
          builder: (context, state) {
            return AnimatedOpacity(
              opacity: state.isUnityVisible ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !state.isUnityVisible,
                child: const UnityView(),
              ),
            );
          },
        ),

        // === Dialog Layer ===
        // Lắng nghe DialogCubit và hiển thị các dialog trong một Stack riêng
        BlocBuilder<DialogCubit, DialogState>(
          builder: (context, state) {
            print('Dialog state: ${state.dialogs}');
            if (state.dialogs.isEmpty) {
              return const SizedBox.shrink();
            }
            // Stack này sẽ chứa tất cả các dialog
            // Chúng sẽ được hiển thị chồng lên nhau theo thứ tự trong list
            return Stack(
              children:
                  state.dialogs.map((dialogInfo) {
                    // Đảm bảo mỗi dialog widget có key duy nhất đã được gán
                    // để Flutter và Cubit có thể quản lý chính xác
                    return KeyedSubtree(
                      key: dialogInfo.key,
                      child: dialogInfo.widget,
                    );
                  }).toList(),
            );
          },
        ),
        // === End Dialog Layer ===

        // Debug view
        BlocSelector<DebugCubit, DebugState, bool>(
          selector: (state) => state.isShowDebugView,
          builder: (context, isShowDebugView) {
            return isShowDebugView
                ? const DebugNavigator()
                : const SizedBox.shrink();
          },
        ),

        // Orientation loading
        MultiBlocListener(
          listeners: [
            BlocListener<AppCubit, AppState>(
              listenWhen:
                  (previous, current) =>
                      previous.orientation != null &&
                      previous.orientation != current.orientation,
              listener: (context, state) {
                context.read<AppCubit>().showLoading();
              },
            ),
            BlocListener<FloatButtonCubit, FloatButtonState>(
              listenWhen:
                  (previous, current) =>
                      !previous.isAnimating && current.isAnimating,
              listener: (context, state) {
                _animationController.reset();
                _animationController.forward();
              },
            ),
            // Lắng nghe trạng thái mua hàng
            BlocListener<PurchasedCubit, PurchasedState>(
              listenWhen: (previous, current) {
                // Lắng nghe khi isVerifyPurchasedSuccess thay đổi thành true
                // Hoặc khi errorMessage thay đổi từ null thành có giá trị
                return (previous.isVerifyPurchasedSuccess !=
                            current.isVerifyPurchasedSuccess &&
                        current.isVerifyPurchasedSuccess == true) ||
                    (previous.errorMessage == null &&
                        current.errorMessage != null);
              },
              listener: (context, state) {
                final context = navigatorKey.currentContext;
                if (context != null) {
                  context.read<PurchasedCubit>().resetStatus();
                  if (state.isVerifyPurchasedSuccess == true) {
                    context.go(AppRoutePaths.purchasedSuccess);
                  } else if (state.errorMessage != null) {
                    try {
                      showLeaveContactDialog(
                        navigatorKey.currentContext!,
                        () => context.go(AppRoutePaths.home),
                      );
                    } catch (e) {
                      logger.severe('Error showing dialog: $e');
                    }
                  }
                }
              },
            ),
          ],
          child: BlocSelector<AppCubit, AppState, bool>(
            selector: (state) => state.isOrientationLoading,
            builder: (context, isLoading) {
              return isLoading
                  ? const OrientationLoading()
                  : const SizedBox.shrink();
            },
          ),
        ),

        // Nút màu vàng có thể kéo thả và tự động đi về viền gần nhất khi buông
        BlocBuilder<DebugCubit, DebugState>(
          builder: (context, state) {
            return state.isModeDebug
                ? BlocBuilder<FloatButtonCubit, FloatButtonState>(
                  builder: (context, state) {
                    return Positioned(
                      left: state.x,
                      top: state.y,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          context.read<FloatButtonCubit>().updatePosition(
                            details.delta.dx,
                            details.delta.dy,
                            size,
                          );
                        },
                        onPanEnd: (_) {
                          context.read<FloatButtonCubit>().snapToNearestEdge(
                            size,
                          );
                        },
                        onTap: () {
                          context.read<DebugCubit>().toggleDebugView();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bug_report,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
