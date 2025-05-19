import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class SelectBottomSheet<T> extends StatelessWidget {
  const SelectBottomSheet({
    super.key,
    this.hintText,
    this.title,
    this.currentLabel,
    this.leading,
    required this.items,
    required this.onChange,
    required this.itemWidget,
  });

  final String? hintText;
  final String? title;
  final Widget? leading;
  final String? currentLabel;
  final List<T> items;
  final void Function(T item) onChange;
  final Widget Function(T item) itemWidget;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrayColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                title?.toUpperCase() ?? '',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const Divider(thickness: 1, color: AppTheme.textGrayLightColor),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.md,
                  horizontal: Spacing.md,
                ),
                child: Column(
                  children: [
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.sm,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onChange(item);
                            Navigator.pop(
                              context,
                            ); // Close bottom sheet after selection
                          },
                          child: itemWidget.call(item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              leading ?? const SizedBox.shrink(),
              if (leading != null) const SizedBox(width: Spacing.md),
              Text(title ?? ''),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showBottomSheet(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.textGrayLightColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentLabel ?? hintText ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        currentLabel == null && hintText != null
                            ? AppTheme.textGrayLightColor
                            : null, // Use default color if there's a label
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
