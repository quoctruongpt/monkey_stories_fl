import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class ExpirationInfo extends StatelessWidget {
  const ExpirationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(
                  (state.purchasedInfo?.timeExpired ?? 0) * 1000,
                );
                int remainingDays =
                    state.purchasedInfo?.isLifetimeUser != true
                        ? (date.difference(DateTime.now()).inDays + 1)
                        : 0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.textGrayLightColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 380 / 132,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/purchased.png',
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.2),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Spacing.md,
                              horizontal: Spacing.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'MONKEY STORIES',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                    'app.expired.date',
                                    params: {
                                      'date':
                                          state.purchasedInfo?.isLifetimeUser !=
                                                  true
                                              ? DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(date)
                                              : AppLocalizations.of(
                                                context,
                                              ).translate('lifetime'),
                                    },
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: Spacing.lg),
                                state.purchasedInfo?.isLifetimeUser != true
                                    ? AppButton.primary(
                                      onPressed: () {
                                        context.pushNamed(
                                          AppRouteNames.renewPlan,
                                        );
                                      },
                                      text: AppLocalizations.of(
                                        context,
                                      ).translate('app.expired.renew'),
                                    )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: -16,
                      right: 24,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/exprire_tag.png',
                            width: 110,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 92,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Html(
                                      data:
                                          state.purchasedInfo?.isLifetimeUser ==
                                                  true
                                              ? '<p class="text">${AppLocalizations.of(context).translate('lifetime')}</p>'
                                              : AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.expired.remaining_days',
                                                params: {
                                                  'count':
                                                      remainingDays.toString(),
                                                },
                                              ),
                                      style: {
                                        '.text': Style(
                                          color: Colors.white,
                                          fontSize: FontSize(16),
                                          fontWeight: FontWeight.w800,
                                          margin: Margins.zero,
                                          padding: HtmlPaddings.zero,
                                          textAlign: TextAlign.center,
                                        ),
                                        '.number': Style(
                                          color: Colors.white,
                                          fontSize: FontSize(36),
                                          fontWeight: FontWeight.w900,
                                          margin: Margins.zero,
                                          padding: HtmlPaddings.zero,
                                          textAlign: TextAlign.center,
                                          lineHeight: LineHeight.em(0.7),
                                        ),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
