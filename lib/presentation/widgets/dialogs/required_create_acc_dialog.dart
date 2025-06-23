import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/di/repositories.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/ms_order_complete_crash_popup.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

void showRequiredCreateAccDialog(BuildContext context) {
  sl<MsOrderCompleteCrashPopupTrackingUsecase>().call(
    MsOrderCompleteCrashPopupTrackingParams(
      source: context.read<PurchasedCubit>().state.source ?? '',
      choosePackage:
          context.read<PurchasedCubit>().state.purchasingItem?.type.value ?? '',
    ),
  );

  showCustomNoticeDialog(
    context: context,
    titleText: AppLocalizations.of(
      context,
    ).translate('app.obd_payment.created_account.title'),
    messageText: AppLocalizations.of(
      context,
    ).translate('app.obd_payment.created_account.desc'),
    imageAsset: 'assets/images/max_warning.png',
    primaryActionText: AppLocalizations.of(
      context,
    ).translate('app.obd_payment.created_account.act'),
    onPrimaryAction: () {
      context.read<UserCubit>().togglePurchasing();
      context.replace(AppRoutePaths.signUp);
    },
    isCloseable: false,
  );
}
