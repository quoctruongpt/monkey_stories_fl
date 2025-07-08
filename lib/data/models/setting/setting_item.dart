// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:monkey_stories/domain/usecases/tracking/setting/ms_parent_setting_detail.dart';

class SettingItem {
  final String icon;
  final String label;
  final String? route;
  final String? value;
  final bool isActive;
  final Future<String?> Function()? valueGetter;
  final Function(BuildContext context)? onTap;
  final bool showArrow;
  final Future<bool> Function(BuildContext context)? isVisibleGetter;
  final ClickType? clickType;

  SettingItem({
    required this.icon,
    required this.label,
    this.route,
    this.value,
    this.isActive = true,
    this.valueGetter,
    this.onTap,
    this.showArrow = true,
    this.isVisibleGetter,
    this.clickType,
  });
}
