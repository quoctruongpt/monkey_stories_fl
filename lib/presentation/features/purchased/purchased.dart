import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/purchase/package_item_with_discount.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_footer.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchase_title.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_content.dart';
import 'package:monkey_stories/presentation/widgets/purchase/purchased_image.dart';

const listContent = [
  '6500+ hoạt động truyện tranh, thơ, bài hát, trò chơi tương tác vui nhộn',
  'Hoạt động cập nhật mới mỗi tuần',
  'Nội dung phù hợp với từng giai đoạn phát triển của trẻ',
];

class PurchasedProvider extends StatelessWidget {
  const PurchasedProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PurchasedViewCubit>()..getPackages(),
      child: const PurchasedScreen(),
    );
  }
}

class PurchasedScreen extends StatelessWidget {
  const PurchasedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            showBackButton: false,
            actions: [
              IconButton(
                onPressed: () => context.go(AppRoutePaths.unity),
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
                            const PurchasedContent(),
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

                  BlocBuilder<PurchasedViewCubit, PurchasedViewState>(
                    builder: (context, state) {
                      final canUseTrial = state.selectedPackage?.canUseTrial;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: PurchaseFooter(
                          description:
                              canUseTrial == true
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
