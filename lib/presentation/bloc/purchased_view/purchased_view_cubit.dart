import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';

part 'purchased_view_state.dart';

final logger = Logger('PurchasedViewCubit');

const sortPackages = [
  PackageType.oneYear,
  PackageType.lifetime,
  PackageType.sixMonth,
];

class PurchasedViewCubit extends Cubit<PurchasedViewState> {
  final PurchasedCubit _purchasedCubit;
  PurchasedViewCubit({required PurchasedCubit purchasedCubit})
    : _purchasedCubit = purchasedCubit,
      super(const PurchasedViewState());

  void selectPackage(PurchasedPackage package) {
    emit(state.copyWith(selectedPackage: package));
  }

  void getOnboardingPackages() {
    logger.info('getOnboardingPackages ${_purchasedCubit.state.products}');
    final packages =
        _purchasedCubit.state.products
            .where((element) => element.type == PackageType.oneYear)
            .toList();

    logger.info('packages: $packages');

    emit(
      state.copyWith(
        packages: packages,
        selectedPackage: packages.isNotEmpty ? packages.first : null,
      ),
    );
  }

  void getPackages() {
    final packages =
        _purchasedCubit.state.products
            .where((element) => sortPackages.contains(element.type))
            .toList();

    packages.sort(
      (a, b) =>
          sortPackages.indexOf(a.type).compareTo(sortPackages.indexOf(b.type)),
    );

    emit(
      state.copyWith(
        packages: packages,
        selectedPackage: packages.isNotEmpty ? packages.first : null,
      ),
    );
  }
}
