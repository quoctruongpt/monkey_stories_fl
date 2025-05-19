import 'dart:async';

import 'package:flutter/widgets.dart';

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
  });
}
