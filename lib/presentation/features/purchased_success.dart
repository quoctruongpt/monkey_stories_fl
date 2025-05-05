import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

class PurchasedSuccessScreen extends StatelessWidget {
  const PurchasedSuccessScreen({super.key});

  void _onPressed(BuildContext context) {
    final state = context.read<PurchasedCubit>().state;
    if (state.isNeedRegister) {
      context.read<UserCubit>().togglePurchasing();
      context.go(AppRoutePaths.signUp);
    } else {
      context.go(AppRoutePaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PurchasedCubit, PurchasedState>(
        builder: (context, state) {
          return SuccessScreen(
            title: 'Thanh toán thành công',
            buttonText: AppLocalizations.of(
              context,
            ).translate(state.isNeedRegister ? 'Đăng ký' : 'Học ngay'),
            onPressed: () => _onPressed(context),
          );
        },
      ),
    );
  }
}
