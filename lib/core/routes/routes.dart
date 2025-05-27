import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/presentation/features/active_license/active_license_navigator.dart';
import 'package:monkey_stories/presentation/features/create_profile/choose_level.dart';
import 'package:monkey_stories/presentation/features/create_profile/choose_year_of_birth.dart';
import 'package:monkey_stories/presentation/features/create_profile/create_profile_loading.dart';
import 'package:monkey_stories/presentation/features/create_profile/input_name_screen.dart';
import 'package:monkey_stories/presentation/features/forgot_password/forgot_password_navigator.dart';
import 'package:monkey_stories/presentation/features/list_profile.dart';
import 'package:monkey_stories/presentation/features/onboarding/intro_screen.dart';
import 'package:monkey_stories/presentation/features/onboarding/obd_navigator.dart';
import 'package:monkey_stories/presentation/features/parent/parent_tab.dart';
import 'package:monkey_stories/presentation/features/parent/report/report.dart';
import 'package:monkey_stories/presentation/features/parent/setting.dart';
import 'package:monkey_stories/presentation/features/parent/vip.dart';
import 'package:monkey_stories/presentation/features/parent_setting/list_profile_setting.dart';
import 'package:monkey_stories/presentation/features/sign_up/sign_up_success_screen.dart';
import 'package:monkey_stories/presentation/features/splash/splash_screen.dart';
import 'package:monkey_stories/presentation/features/unity/unity_screen.dart';
import 'package:monkey_stories/presentation/features/home_screen.dart';
import 'package:monkey_stories/presentation/features/sign_in/login_screen.dart';
import 'package:monkey_stories/presentation/features/result_screen.dart';
import 'package:monkey_stories/presentation/features/sign_up/sign_up_screen.dart';
import 'package:monkey_stories/presentation/features/webview.dart';
import 'package:monkey_stories/presentation/widgets/orientation_wrapper.dart';
import 'package:monkey_stories/presentation/features/purchased_success.dart';
import 'package:monkey_stories/presentation/features/parent_setting/user_info.dart';
import 'package:monkey_stories/presentation/features/parent_setting/edit_profile_info.dart';
import 'package:monkey_stories/presentation/features/parent_setting/change_password.dart';
import 'package:monkey_stories/presentation/features/parent_setting/change_password_success.dart';
import 'package:monkey_stories/presentation/features/parent_setting/general_setting.dart';
import 'package:monkey_stories/presentation/features/parent_setting/schedule_manager.dart';

final logger = Logger('router');

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _reportTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'reportTab');
final GlobalKey<NavigatorState> _vipTabNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'vipTab',
);
final GlobalKey<NavigatorState> _settingTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settingTab');

final GoRouter router = GoRouter(
  observers: [routeObserver],
  navigatorKey: navigatorKey,
  initialLocation: AppRoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.intro,
      name: AppRouteNames.intro,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: IntroScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.splash,
      name: AppRouteNames.splash,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SplashScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.home,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: MyHomePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.result,
      name: AppRouteNames.result,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.landscapeLeft,
          child: ResultScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.unity,
      name: AppRouteNames.unity,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.landscapeLeft,
          child: UnityScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.login,
      name: AppRouteNames.login,
      builder: (context, state) {
        final String? initialUsername = state.uri.queryParameters['username'];
        final String? initialPassword = state.uri.queryParameters['password'];
        return LoginScreenProvider(
          initialUsername: initialUsername,
          initialPassword: initialPassword,
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.signUp,
      name: AppRouteNames.signUp,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SignUpScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.signUpSuccess,
      name: AppRouteNames.signUpSuccess,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: SignUpSuccessScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.createProfileInputName,
      name: AppRouteNames.createProfileInputName,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileInputNameScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileInputDateOfBirth,
      name: AppRouteNames.createProfileInputDateOfBirth,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileChooseYearOfBirthScreen(name: name),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileChooseLevel,
      name: AppRouteNames.createProfileChooseLevel,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        final int yearOfBirth = int.parse(
          state.uri.queryParameters['yearOfBirth'] ?? '0',
        );
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ChooseLevelScreen(name: name, yearOfBirth: yearOfBirth),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.createProfileLoading,
      name: AppRouteNames.createProfileLoading,
      builder: (context, state) {
        final String name = state.uri.queryParameters['name'] ?? '';
        final int yearOfBirth = int.parse(
          state.uri.queryParameters['yearOfBirth'] ?? '0',
        );
        final int levelId = int.parse(
          state.uri.queryParameters['levelId'] ?? '0',
        );
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: CreateProfileLoadingScreen(
            name: name,
            yearOfBirth: yearOfBirth,
            levelId: levelId,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.purchasedSuccess,
      name: AppRouteNames.purchasedSuccess,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: PurchasedSuccessScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.listProfile,
      name: AppRouteNames.listProfile,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ListProfile(),
        );
      },
    ),

    // StatefulShellRoute for Parent Tabs
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return ParentTab(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch for Report Tab
        StatefulShellBranch(
          navigatorKey: _reportTabNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.report, // Assuming this is '/parent/report'
              name:
                  AppRouteNames
                      .report, // Optional: if you have names for these routes
              builder:
                  (BuildContext context, GoRouterState state) =>
                      const OrientationWrapper(
                        orientation: AppOrientation.portrait,
                        child: ReportScreen(),
                      ),
            ),
          ],
        ),
        // Branch for VIP Tab
        StatefulShellBranch(
          navigatorKey: _vipTabNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.vip, // Assuming this is '/parent/vip'
              name: AppRouteNames.vip, // Optional
              builder:
                  (BuildContext context, GoRouterState state) =>
                      const OrientationWrapper(
                        orientation: AppOrientation.portrait,
                        child: VipScreen(),
                      ),
            ),
          ],
        ),
        // Branch for Setting Tab
        StatefulShellBranch(
          navigatorKey: _settingTabNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.setting, // Assuming this is '/parent/setting'
              name: AppRouteNames.setting, // Optional
              builder:
                  (BuildContext context, GoRouterState state) =>
                      const OrientationWrapper(
                        orientation: AppOrientation.portrait,
                        child: SettingScreen(),
                      ),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutePaths.userInfo,
      name: AppRouteNames.userInfo,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: UserInfo(),
        );
      },
    ),

    GoRoute(
      path: AppRoutePaths.listProfileSetting,
      name: AppRouteNames.listProfileSetting,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ListProfileSetting(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.editProfileInfo,
      name: AppRouteNames.editProfileInfo,
      builder: (context, state) {
        final int profileId = int.parse(
          state.uri.queryParameters['profileId'] ?? '0',
        );

        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: EditProfileInfo(profileId: profileId),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.webView,
      name: AppRouteNames.webView,
      builder: (context, state) {
        return OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: WebViewScreen(
            title: state.uri.queryParameters['title'] ?? '',
            url: state.uri.queryParameters['url'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.changePassword,
      name: AppRouteNames.changePassword,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ChangePassword(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.changePasswordSuccess,
      name: AppRouteNames.changePasswordSuccess,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ChangePasswordSuccess(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.generalSetting,
      name: AppRouteNames.generalSetting,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: GeneralSettingScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.scheduleManager,
      name: AppRouteNames.scheduleManager,
      builder: (context, state) {
        return const OrientationWrapper(
          orientation: AppOrientation.portrait,
          child: ScheduleManager(),
        );
      },
    ),

    forgotPasswordRoutes,
    obdRoutes,
    activeLicenseRoutes,
  ],
);
