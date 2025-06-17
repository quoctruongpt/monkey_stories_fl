import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/ms_purchase_screen_buy_now.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/ms_purchase_screen_click_exit.dart';
import 'package:monkey_stories/domain/usecases/tracking/payment/ms_purchase_screen_view.dart';
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
  final MsPurchaseScreenViewTrackingUsecase
  _msPurchaseScreenViewTrackingUsecase;
  final MsPurchaseScreenBuyNowTrackingUsecase
  _msPurchaseScreenBuyNowTrackingUsecase;
  final MsPurchaseScreenClickExitTrackingUsecase
  _msPurchaseScreenClickExitTrackingUsecase;

  PurchasedViewCubit({
    required PurchasedCubit purchasedCubit,
    required MsPurchaseScreenViewTrackingUsecase
    msPurchaseScreenViewTrackingUsecase,
    required MsPurchaseScreenBuyNowTrackingUsecase
    msPurchaseScreenBuyNowTrackingUsecase,
    required MsPurchaseScreenClickExitTrackingUsecase
    msPurchaseScreenClickExitTrackingUsecase,
  }) : _purchasedCubit = purchasedCubit,
       _msPurchaseScreenViewTrackingUsecase =
           msPurchaseScreenViewTrackingUsecase,
       _msPurchaseScreenBuyNowTrackingUsecase =
           msPurchaseScreenBuyNowTrackingUsecase,
       _msPurchaseScreenClickExitTrackingUsecase =
           msPurchaseScreenClickExitTrackingUsecase,
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

  void onClose(String source) {
    _msPurchaseScreenClickExitTrackingUsecase.call(
      MsPurchaseScreenClickExitTrackingParams(source: source),
    );
  }

  void trackScreenView(String source) {
    _msPurchaseScreenViewTrackingUsecase.call(
      MsPurchaseScreenViewTrackingParams(
        source: source,
        tagName01: 'ms_flow_current',
      ),
    );
  }

  void trackScreenBuyNow(String source) {
    _msPurchaseScreenBuyNowTrackingUsecase.call(
      MsPurchaseScreenBuyNowTrackingParams(
        source: source,
        choosePackage: state.selectedPackage?.type.value ?? '',
      ),
    );
  }
}
