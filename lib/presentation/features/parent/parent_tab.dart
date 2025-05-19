import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class ParentTab extends StatelessWidget {
  const ParentTab({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
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
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/svg/report_inactive.svg'),
            activeIcon: SvgPicture.asset('assets/icons/svg/report_active.svg'),
            label: AppLocalizations.of(context).translate('app.report.title'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/svg/vip_inactive.svg'),
            activeIcon: SvgPicture.asset('assets/icons/svg/vip_active.svg'),
            label: AppLocalizations.of(context).translate('app.vip.title'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/svg/setting_tab_inactive.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset('assets/icons/svg/setting_active.svg'),
            label: AppLocalizations.of(context).translate('app.setting.title'),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            context.go(AppRoutePaths.unity);
          },
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
      ),
    );
  }
}
