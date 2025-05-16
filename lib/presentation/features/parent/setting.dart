import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/setting.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/enhanced_setting_item.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate('app.setting.label'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: ListView.builder(
          itemCount: settingsData.length + 1,
          itemBuilder: (context, sectionIndex) {
            if (sectionIndex == settingsData.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/mom_choice.png',
                      width: 83,
                      height: 79,
                    ),
                    const SizedBox(width: Spacing.md),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/kid_safe.png',
                          width: 172,
                          height: 78,
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Text(
                            'www.kidsafeseal.com',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            final section = settingsData[sectionIndex];
            final List<dynamic> itemsInSection =
                section['items'] as List<dynamic>;

            List<Widget> sectionWidgets = [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  AppLocalizations.of(context).translate(section['title']),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textGrayLightColor,
                  ),
                ),
              ),
            ];

            for (int i = 0; i < itemsInSection.length; i++) {
              final currentItem = itemsInSection[i];
              final nextItem =
                  (i + 1 < itemsInSection.length)
                      ? itemsInSection[i + 1]
                      : null;

              sectionWidgets.add(
                EnhancedSettingItem(
                  currentItemModel: currentItem,
                  nextItemModel: nextItem,
                ),
              );
            }

            if (sectionIndex == settingsData.length - 1) {
              sectionWidgets.add(const SizedBox(height: Spacing.md));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sectionWidgets,
            );
          },
        ),
      ),
    );
  }
}
