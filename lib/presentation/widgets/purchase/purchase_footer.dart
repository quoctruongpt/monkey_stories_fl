import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/purchase/terms_bottomsheet.dart';

class PurchaseFooter extends StatelessWidget {
  const PurchaseFooter({
    super.key,
    required this.onPressed,
    required this.onRestorePressed,
    required this.onTermsPressed,
    required this.description,
    required this.actionText,
  });

  final VoidCallback onPressed;
  final VoidCallback onRestorePressed;
  final VoidCallback onTermsPressed;
  final String description;
  final String actionText;

  void _onTermsPressed(BuildContext context) {
    showTermsBottomSheet(context);
    onTermsPressed();
  }

  void _onRestorePressed(BuildContext context) {
    context.read<PurchasedCubit>().restorePurchase();
    onRestorePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppButton.primary(text: actionText, onPressed: onPressed),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              TextButton(
                onPressed: () => _onTermsPressed(context),
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
                onPressed: () => _onRestorePressed(context),
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
