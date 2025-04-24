import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/purchase/package_item.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_footer.dart';
import 'package:monkey_stories/presentation/widgets/parent_verify.dart';

class ObdPurchaseProvider extends StatelessWidget {
  const ObdPurchaseProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PurchasedViewCubit>()..getOnboardingPackages(),
      child: const ObdPurchase(),
    );
  }
}

class ObdPurchase extends StatelessWidget {
  const ObdPurchase({super.key});

  void _onXPressed(BuildContext context) {
    context.go(AppRoutePaths.home);
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
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(color: AppTheme.azureColor),
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: BlocBuilder<
                          PurchasedViewCubit,
                          PurchasedViewState
                        >(
                          builder: (context, state) {
                            return Column(
                              children:
                                  state.packages
                                      .map(
                                        (e) => PackageItemView(
                                          price: e.localPrice,
                                          priceForOneMonth:
                                              e.localPriceForOneMonth,
                                          originalPrice: e.localOriginalPrice,
                                          isRecommended:
                                              e.type == PackageType.oneYear,
                                          isSelected:
                                              e.id == state.selectedPackage?.id,
                                          type: e.type,
                                        ),
                                      )
                                      .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Spacing.md),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: BlocBuilder<PurchasedViewCubit, PurchasedViewState>(
                    builder: (context, state) {
                      final canUseTrial = state.selectedPackage?.canUseTrial;
                      return PurchaseFooter(
                        description:
                            canUseTrial == true
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
                                  'app.obd_payment.desc.trial',
                                  params: {
                                    'price': state.selectedPackage?.localPrice,
                                    'time': AppLocalizations.of(
                                      context,
                                    ).translate(
                                      state.selectedPackage?.type.value,
                                    ),
                                  },
                                ),
                        onPressed: () {
                          showVerifyDialog(
                            context: context,
                            onSuccess: () {
                              context.read<PurchasedCubit>().purchase(
                                state.selectedPackage!,
                              );
                            },
                          );
                        },
                        onRestorePressed: () {},
                        onTermsPressed: () {},
                        actionText: AppLocalizations.of(context).translate(
                          canUseTrial == true
                              ? 'app.obd_payment.act.trial'
                              : 'app.obd_payment.act.not_trial',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
