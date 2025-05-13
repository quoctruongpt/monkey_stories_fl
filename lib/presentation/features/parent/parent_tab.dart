import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/svg/vip_inactive.svg'),
            activeIcon: SvgPicture.asset('assets/icons/svg/vip_active.svg'),
            label: 'VIP',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/svg/setting_tab_inactive.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset('assets/icons/svg/setting_active.svg'),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
