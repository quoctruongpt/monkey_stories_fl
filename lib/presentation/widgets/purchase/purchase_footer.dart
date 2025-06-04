import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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
        FittedBox(
          child: Html(
            data: description,
            style: {
              'b': Style(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w700,
              ),
              'body': Style(
                textAlign: TextAlign.center,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: FontSize(14),
                maxLines: 1,
                textOverflow: TextOverflow.clip,
              ),
            },
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
