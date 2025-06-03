import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';

part 'unity_screen_state.dart';

final logger = Logger('UnityScreenCubit');

class UnityScreenCubit extends Cubit<UnityScreenState> {
  final PurchasedCubit _purchasedCubit;
  UnityScreenCubit({required PurchasedCubit purchasedCubit})
    : _purchasedCubit = purchasedCubit,
      super(const UnityScreenState());

  void buyNow() {
    logger.info('buyNow');
    final packageSelected = _purchasedCubit.state.products.firstWhere(
      (element) => element.type == PackageType.oneYear,
    );
    logger.info('packageSelected: ${packageSelected.id}');
    _purchasedCubit.purchase(packageSelected);
  }
}
