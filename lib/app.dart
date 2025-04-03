import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/blocs/debug/debug_cubit.dart';
import 'package:monkey_stories/blocs/orientation/orientation_cubit.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/core/localization/app_localizations_delegate.dart';
import 'package:monkey_stories/core/navigation/router.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/widgets/debug_view_widget.dart';
import 'package:monkey_stories/widgets/orientation_loading_widget.dart';
import 'package:monkey_stories/widgets/unity_widget.dart';

final logger = Logger('MyApp');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UnityCubit()),
        BlocProvider(create: (_) => OrientationCubit()),
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => DebugCubit()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen:
            (previous, current) =>
                previous.languageCode != current.languageCode,
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('vi')],
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

class AppBuilder extends StatelessWidget {
  final Widget? child;
  const AppBuilder({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hiển thị nội dung chính của ứng dụng
        child ?? const SizedBox.shrink(),

        // Unity Widget sẽ đè lên UI khi cần thiết
        BlocBuilder<UnityCubit, UnityState>(
          buildWhen:
              (previous, current) =>
                  previous.isUnityVisible != current.isUnityVisible,
          builder: (context, state) {
            final size = MediaQuery.of(context).size;
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: state.isUnityVisible ? 0 : -size.width,
              top: 0,
              right: state.isUnityVisible ? 0 : size.width,
              bottom: 0,
              child: const UnityView(),
            );
          },
        ),

        // Debug view
        BlocSelector<DebugCubit, DebugState, bool>(
          selector: (state) => state.isShowDebugView,
          builder: (context, isShowDebugView) {
            return isShowDebugView
                ? Material(
                  child: Navigator(
                    onGenerateRoute:
                        (settings) => MaterialPageRoute(
                          builder: (context) => const DebugViewWidget(),
                        ),
                  ),
                )
                : const SizedBox.shrink();
          },
        ),

        // Orientation loading
        MultiBlocListener(
          listeners: [
            BlocListener<OrientationCubit, OrientationState>(
              listenWhen:
                  (previous, current) =>
                      previous.orientation != current.orientation,
              listener: (context, state) {
                context.read<AppCubit>().showLoading();
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
      ],
    );
  }
}
