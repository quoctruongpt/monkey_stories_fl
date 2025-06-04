import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/features/parent/expiration_info.dart';
import 'package:monkey_stories/presentation/features/purchased/vip_purchased.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return state.purchasedInfo?.status == PurchasedStatus.active
            ? const ExpirationInfo()
            : const VipPurchasedProvider();
      },
    );
  }
}
