import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PurchasedImage extends StatelessWidget {
  const PurchasedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height =
            (width * 250) / 380; // Tính toán chiều cao dựa trên tỷ lệ 380:250

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/purchased.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: height * 0.67,
                left: width * 0.04,
                right: width * 0.04,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 40,
                    maxHeight: height * 0.25,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(height * 0.06),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              'assets/images/app_of_the_day.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: height * 0.025),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/rice_flower_left.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).translate('app.intro.user'),
                                      style: TextStyle(
                                        fontSize: height * 0.032,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.azureColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/rice_flower_right.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: height * 0.025),
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              'assets/images/editor_choice.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
