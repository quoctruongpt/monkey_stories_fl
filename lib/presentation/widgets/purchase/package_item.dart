import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PackageItemView extends StatelessWidget {
  const PackageItemView({
    super.key,
    required this.price,
    required this.priceForOneMonth,
    required this.originalPrice,
    required this.type,
    this.isRecommended = false,
    this.isSelected = false,
  });

  final String price;
  final String priceForOneMonth;
  final String originalPrice;
  final PackageType type;
  final bool? isRecommended;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color:
                  isSelected == true
                      ? AppTheme.azureColor
                      : AppTheme.textGrayColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$originalPrice/${AppLocalizations.of(context).translate(type.value)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textGrayColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$price/${AppLocalizations.of(context).translate(type.value)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.azureColor,
                    ),
                  ),
                  Text(
                    '$priceForOneMonth/${AppLocalizations.of(context).translate(PackageType.oneMonth.value)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textGrayColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: -20,
          left: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text(
                AppLocalizations.of(
                  context,
                ).translate('app.purchase.package_item.recommended'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
