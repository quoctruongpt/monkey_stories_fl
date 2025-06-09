import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';

class _BottomRightHigherFabLocation extends FloatingActionButtonLocation {
  const _BottomRightHigherFabLocation({required this.currentIndex});

  final int currentIndex;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset defaultOffset = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);

    // VIP tab is at index 1
    final double verticalOffset = (currentIndex == 1) ? 150.0 : 0.0;

    return Offset(defaultOffset.dx, defaultOffset.dy - verticalOffset);
  }
}

class ParentTab extends StatelessWidget {
  const ParentTab({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _handlePlayPressed(BuildContext context) {
    if (context.read<ProfileCubit>().state.currentProfile == null) {
      context.go(AppRoutePaths.listProfile);
      return;
    }
    context.go(AppRoutePaths.unity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BottomNavigationCubit>(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          final isBottomNavVisible = state.isBottomNavVisible;

          return Scaffold(
            body: navigationShell,
            floatingActionButtonLocation: _BottomRightHigherFabLocation(
              currentIndex: navigationShell.currentIndex,
            ),
            bottomNavigationBar: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  axisAlignment: 1.0, // Grow from bottom, shrink to bottom
                  child: child,
                );
              },
              child:
                  isBottomNavVisible
                      ? Theme(
                        key: const ValueKey('actual_bottom_nav'),
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: BottomNavigationBar(
                          currentIndex: navigationShell.currentIndex,
                          selectedItemColor: AppTheme.azureColor,
                          unselectedItemColor: AppTheme.textGrayLightColor,
                          selectedLabelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                          type: BottomNavigationBarType.fixed,
                          onTap: (index) {
                            if (index == navigationShell.currentIndex) {
                              return;
                            }
                            navigationShell.goBranch(index);
                          },
                          items: [
                            BottomNavigationBarItem(
                              icon: SvgPicture.asset(
                                'assets/icons/svg/report_inactive.svg',
                              ),
                              activeIcon: SvgPicture.asset(
                                'assets/icons/svg/report_active.svg',
                              ),
                              label: AppLocalizations.of(
                                context,
                              ).translate('app.report.title'),
                            ),
                            BottomNavigationBarItem(
                              icon: SvgPicture.asset(
                                'assets/icons/svg/vip_inactive.svg',
                              ),
                              activeIcon: SvgPicture.asset(
                                'assets/icons/svg/vip_active.svg',
                              ),
                              label: AppLocalizations.of(
                                context,
                              ).translate('app.vip.title'),
                            ),
                            BottomNavigationBarItem(
                              icon: SvgPicture.asset(
                                'assets/icons/svg/setting_tab_inactive.svg',
                                width: 24,
                                height: 24,
                              ),
                              activeIcon: SvgPicture.asset(
                                'assets/icons/svg/setting_active.svg',
                              ),
                              label: AppLocalizations.of(
                                context,
                              ).translate('app.setting.title'),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(
                        key: ValueKey('empty_bottom_nav'),
                      ),
            ),
            floatingActionButton: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child:
                  isBottomNavVisible
                      ? SizedBox(
                        key: const ValueKey('actual_fab'),
                        width: 80,
                        height: 80,
                        child: FloatingActionButton(
                          onPressed: () => _handlePlayPressed(context),
                          backgroundColor: const Color(0xFFFFBB00),
                          mini: false,
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white, width: 4),
                          ),
                          child: Image.asset(
                            'assets/icons/img/play.png',
                            width: 33,
                            height: 36,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(key: ValueKey('empty_fab')),
            ),
          );
        },
      ),
    );
  }
}
