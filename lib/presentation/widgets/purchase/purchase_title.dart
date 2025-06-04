import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PurchaseTitle extends StatelessWidget {
  const PurchaseTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate('Mở khóa toàn bộ nội dung'),
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(color: AppTheme.azureColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          AppLocalizations.of(context).translate(
            'Gia nhập cộng đồng 15 triệu phụ huynh thông thái! Giúp con giỏi tiếng anh trước tuổi lên 10!',
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
