import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/order_complete.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

class PurchasedSuccessScreen extends StatefulWidget {
  const PurchasedSuccessScreen({super.key, required this.source});

  final String source;

  @override
  State<PurchasedSuccessScreen> createState() => _PurchasedSuccessScreenState();
}

class _PurchasedSuccessScreenState extends State<PurchasedSuccessScreen> {
  late PurchasedCubit _purchasedCubit;
  ClickType _clickType = ClickType.killApp;

  @override
  void initState() {
    super.initState();
    _purchasedCubit = context.read<PurchasedCubit>();
  }

  void _onPressed(BuildContext context) {
    _clickType = ClickType.learnNow;
    final state = context.read<PurchasedCubit>().state;
    if (state.isNeedRegister) {
      context.read<UserCubit>().togglePurchasing();
      context.go(AppRoutePaths.signUp);
    } else {
      context.go(AppRoutePaths.home);
    }
  }

  void _onTrackExit() {
    sl<OrderCompleteTrackingUsecase>().call(
      OrderCompleteTrackingParams(
        totalPrice: _purchasedCubit.state.purchasingItem?.price ?? 0,
        source: widget.source,
        choosePackage: _purchasedCubit.state.purchasingItem?.type.value ?? '',
        clickType: _clickType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTracker(
      routeName: AppRouteNames.purchasedSuccess,
      onTrackExit: _onTrackExit,
      child: Scaffold(
        body: BlocBuilder<PurchasedCubit, PurchasedState>(
          builder: (context, state) {
            return SuccessScreen(
              title: 'app.payment.success',
              buttonText: AppLocalizations.of(context).translate(
                state.isNeedRegister
                    ? 'app.payment.register'
                    : 'app.payment.study',
              ),
              onPressed: () => _onPressed(context),
            );
          },
        ),
      ),
    );
  }
}
