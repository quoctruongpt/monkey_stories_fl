import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.lightGrayColor,
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
    );
  }
}
