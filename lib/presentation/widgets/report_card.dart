import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.title,
    this.child,
    this.iconWidget,
  });

  final String title;
  final Widget? child;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D0A2C).withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              iconWidget ?? const SizedBox.shrink(),
              iconWidget != null
                  ? const SizedBox(width: Spacing.md)
                  : const SizedBox.shrink(),
              Text(title, style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
          const SizedBox(height: Spacing.md),
          const Divider(
            color: AppTheme.buttonSecondaryDisabledBackground,
            thickness: 1,
          ),
          const SizedBox(height: Spacing.xl),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
