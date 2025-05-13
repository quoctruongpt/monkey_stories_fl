// lib/widgets/setting_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/data/models/setting/setting_item.dart';

class SettingItemWidget extends StatelessWidget {
  final SettingItem item;

  const SettingItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: SvgPicture.asset(item.icon, width: 24, height: 24),
      title: Text(
        item.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppTheme.textColor,
        ),
      ),
      trailing:
          item.route != null
              ? const Icon(Icons.arrow_forward_ios, size: 20)
              : item.valueGetter != null
              ? FutureBuilder<String?>(
                future: item.valueGetter!(),
                builder: (context, snapshot) {
                  return SelectableText(
                    snapshot.data ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textGrayLightColor,
                    ),
                  );
                },
              )
              : null,
      onTap:
          item.route != null
              ? () => context.push(item.route!)
              : item.onTap != null
              ? () => item.onTap!(context)
              : null,
    );
  }
}
