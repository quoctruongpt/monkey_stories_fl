import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/usecases/purchased/get_products_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/initial_purchased_usecase.dart';

part 'purchased_state.dart';

final Logger logger = Logger('PurchasedCubit');

class PurchasedCubit extends HydratedCubit<PurchasedState> {
  final InitialPurchasedUsecase _initialPurchasedUsecase;
  final GetProductsUsecase _getProductsUsecase;

  PurchasedCubit({
    required InitialPurchasedUsecase initialPurchasedUsecase,
    required GetProductsUsecase getProductsUsecase,
  }) : _initialPurchasedUsecase = initialPurchasedUsecase,
       _getProductsUsecase = getProductsUsecase,
       super(const PurchasedState()) {
    logger.info('PurchasedCubit constructor executed.');
  }

  Future<void> initialPurchased() async {
    final result = await _initialPurchasedUsecase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isInitialPurchased: false)),
      (success) => emit(state.copyWith(isInitialPurchased: true)),
    );
  }

  Future<void> getProducts() async {
    try {
      emit(state.copyWith(isLoadingProducts: true));
      final result = await _getProductsUsecase(NoParams());
      result.fold(
        (failure) => emit(
          state.copyWith(isLoadingProducts: false, isGetProductsSuccess: false),
        ),
        (products) {
          emit(
            state.copyWith(
              isLoadingProducts: false,
              isGetProductsSuccess: true,
              products: products,
            ),
          );
        },
      );
    } catch (e) {}
  }

  void test() {
    logger.info('test');
  }

  @override
  PurchasedState? fromJson(Map<String, dynamic> json) {
    return PurchasedState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(PurchasedState state) {
    return state.toJson();
  }
}
