// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/purchase/package_item_with_discount.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_footer.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_title.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_content.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_image.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

// import 'package:monkey_stories/core/constants/purchased.dart';

const listContent = [
  PurchasedContentItem(text: 'app.obd_payment.content1', tag: 'NEW'),
  PurchasedContentItem(text: 'app.obd_payment.content2'),
  PurchasedContentItem(text: 'app.obd_payment.content3'),
];

class ObdPurchaseProvider extends StatelessWidget {
  const ObdPurchaseProvider({super.key});

  final String source = 'onboarding';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PurchasedViewCubit>()..getPackages(),
      child: Builder(
        builder: (context) {
          return ScreenTracker(
            routeName: AppRouteNames.obdPurchase,
            child: ObdPurchase(source: source),
            onTrackPush: () {
              context.read<PurchasedViewCubit>().trackScreenView(source);
            },
          );
        },
      ),
    );
  }
}

class ObdPurchase extends StatelessWidget {
  final String source;
  const ObdPurchase({super.key, required this.source});

  void _onXPressed(BuildContext context) {
    context.read<PurchasedViewCubit>().onClose(source);
    context.push(AppRoutePaths.leaveContact);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            showBackButton: false,
            actions: [
              IconButton(
                onPressed: () => _onXPressed(context),
                icon: const Icon(
                  Icons.clear,
                  color: AppTheme.textColor,
                  size: 40,
                ),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: BlocBuilder<PurchasedViewCubit, PurchasedViewState>(
            builder: (context, viewState) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top,
                            ),
                            const PurchaseTitle(),
                            const SizedBox(height: Spacing.md),
                            const PurchasedImage(),
                            const SizedBox(height: Spacing.md),
                            const PurchasedContent(listContent: listContent),
                            const SizedBox(height: Spacing.md),
                            BlocBuilder<PurchasedCubit, PurchasedState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    ...viewState.packages.map(
                                      (e) => PackageItem(
                                        package: e,
                                        isSelected:
                                            e.id ==
                                            viewState.selectedPackage?.id,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: Spacing.lg),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: AppTheme.lightGrayColor),
                  const SizedBox(height: Spacing.sm),

                  BlocBuilder<PurchasedViewCubit, PurchasedViewState>(
                    builder: (context, state) {
                      final canUseTrial = state.selectedPackage?.canUseTrial;
                      final isLifetime =
                          state.selectedPackage?.isSubscription == false;
                      final description =
                          isLifetime
                              ? AppLocalizations.of(context).translate(
                                'app.obd_payment.desc.life_time',
                                params: {
                                  'price': state.selectedPackage?.localPrice,
                                },
                              )
                              : canUseTrial == true
                              ? AppLocalizations.of(context).translate(
                                'app.obd_payment.desc.trial',
                                params: {
                                  'price': state.selectedPackage?.localPrice,
                                  'time': AppLocalizations.of(
                                    context,
                                  ).translate(
                                    state.selectedPackage?.type.value,
                                  ),
                                },
                              )
                              : AppLocalizations.of(context).translate(
                                'app.obd_payment.desc.not_trial',
                                params: {
                                  'price': state.selectedPackage?.localPrice,
                                  'time': AppLocalizations.of(
                                    context,
                                  ).translate(
                                    state.selectedPackage?.type.value,
                                  ),
                                },
                              );

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: PurchaseFooter(
                          description: description,
                          onPressed: () {
                            context
                                .read<PurchasedViewCubit>()
                                .trackScreenBuyNow(source);
                            context.read<PurchasedCubit>().purchase(
                              state.selectedPackage!,
                              source: source,
                            );
                          },
                          onRestorePressed: () {},
                          onTermsPressed: () {},
                          actionText: AppLocalizations.of(context).translate(
                            canUseTrial == true
                                ? 'app.obd_payment.act.trial'
                                : 'app.obd_payment.act.not_trial',
                          ),
                          source: source,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),

        BlocBuilder<PurchasedCubit, PurchasedState>(
          builder: (context, state) {
            return state.isPurchasing
                ? const LoadingOverlay()
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
