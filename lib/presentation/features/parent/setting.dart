import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/setting.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/setting_item_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate('Dành cho phụ huynh'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: ListView.builder(
          itemCount: settingsData.length + 1,
          itemBuilder: (context, index) {
            if (index == settingsData.length) {
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

            final section = settingsData[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ...List.generate(section['items'].length * 2 - 1, (
                  itemGenIndex,
                ) {
                  if (itemGenIndex.isEven) {
                    final itemIndex = itemGenIndex ~/ 2;
                    final item = section['items'][itemIndex];
                    return SettingItemWidget(item: item);
                  } else {
                    return const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE5E5E5),
                    );
                  }
                }),
                if (index == settingsData.length - 1)
                  const SizedBox(height: Spacing.md),
              ],
            );
          },
        ),
      ),
    );
  }
}
