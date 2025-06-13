import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/purchase/package_item_with_discount.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_footer.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_title.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_content.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_image.dart';

const listContent = [
  'app.purchased.content1',
  'app.purchased.content2',
  'app.purchased.content3',
];

class VipPurchasedProvider extends StatelessWidget {
  const VipPurchasedProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PurchasedViewCubit>()..getPackages(),
      child: const VipPurchasedScreen(),
    );
  }
}

class VipPurchasedScreen extends StatelessWidget {
  const VipPurchasedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                            const SizedBox(height: Spacing.md),
                            const PurchasedContent(),
                            const SizedBox(height: Spacing.md),
                            const PurchasedImage(),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: PurchaseFooter(
                          description:
                              isLifetime
                                  ? AppLocalizations.of(context).translate(
                                    'app.obd_payment.desc.life_time',
                                    params: {
                                      'price':
                                          state.selectedPackage?.localPrice,
                                    },
                                  )
                                  : canUseTrial == true
                                  ? AppLocalizations.of(context).translate(
                                    'app.obd_payment.desc.trial',
                                    params: {
                                      'price':
                                          state.selectedPackage?.localPrice,
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
                                      'price':
                                          state.selectedPackage?.localPrice,
                                      'time': AppLocalizations.of(
                                        context,
                                      ).translate(
                                        state.selectedPackage?.type.value,
                                      ),
                                    },
                                  ),
                          onPressed: () {
                            context.read<PurchasedCubit>().purchase(
                              state.selectedPackage!,
                            );
                          },
                          onRestorePressed: () {},
                          onTermsPressed: () {},
                          actionText: AppLocalizations.of(context).translate(
                            canUseTrial == true
                                ? 'app.obd_payment.act.trial'
                                : 'app.obd_payment.act.not_trial',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),

        BlocConsumer<PurchasedCubit, PurchasedState>(
          listenWhen:
              (previous, current) =>
                  previous.isPurchasing != current.isPurchasing,
          listener: (context, state) {
            context.read<BottomNavigationCubit>().setBottomNavVisible(
              !state.isPurchasing,
            );
          },
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
