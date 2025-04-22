import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/purchase/package_item.dart';
import 'package:monkey_stories/presentation/widgets/purchase_footer.dart';

class ObdPurchase extends StatelessWidget {
  const ObdPurchase({super.key});

  void _onXPressed(BuildContext context) {
    context.go(AppRoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => _onXPressed(context),
            icon: const Icon(Icons.clear, color: AppTheme.textColor, size: 40),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.lg),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('app.obd_purchase.title'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.azureColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.md),

                  Flexible(
                    child: Image.asset('assets/images/obd_purchase.png'),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/editor_choice.png'),
                      const SizedBox(width: Spacing.lg),
                      Image.asset('assets/images/app_of_the_day.png'),
                    ],
                  ),
                  const SizedBox(height: Spacing.xxl),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: PackageItem(
                      price: '1.399.000 VND/Năm',
                      isRecommended: true,
                      isSelected: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Spacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: PurchaseFooter(
                onPressed: () {},
                onRestorePressed: () {},
                onTermsPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
