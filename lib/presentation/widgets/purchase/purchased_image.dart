import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PurchasedImage extends StatelessWidget {
  const PurchasedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/purchased.png'),
        Positioned(
          bottom: 10,
          left: 16,
          right: 16,
          child: Container(
            height: 69,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/app_of_the_day.png',
                      width: 86,
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/rice_flower_left.png',
                          width: 20,
                          height: 442,
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              ).translate('10 triệu phụ huynh\n tin dùng'),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.azureColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/rice_flower_right.png',
                          width: 20,
                          height: 442,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Flexible(
                    child: Image.asset(
                      'assets/images/editor_choice.png',
                      width: 86,
                      height: 42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
