import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class PurchaseFooter extends StatelessWidget {
  const PurchaseFooter({
    super.key,
    required this.onPressed,
    required this.onRestorePressed,
    required this.onTermsPressed,
  });

  final VoidCallback onPressed;
  final VoidCallback onRestorePressed;
  final VoidCallback onTermsPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(
            context,
          ).translate('699.000đ/ năm sau 7 ngày dùng thử'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.azureColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppButton.primary(
          text: AppLocalizations.of(context).translate('Mua ngay'),
          onPressed: onPressed,
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              TextButton(
                onPressed: onTermsPressed,
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('app.purchase.footer.terms'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.azureColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.azureColor,
                  shape: BoxShape.circle,
                ),
              ),
              TextButton(
                onPressed: onRestorePressed,
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('app.purchase.footer.restore'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.azureColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
