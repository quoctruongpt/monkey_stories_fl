import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/usecases/purchased/complete_purchase_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/dispose_purchse_error_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/get_products_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/initial_purchased_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/listen_to_purchase_error_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/listen_to_purchse_updated_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/puchase_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/restore_purchased_usecase.dart';
import 'package:monkey_stories/domain/usecases/purchased/verify_purchased_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

part 'purchased_state.dart';

final Logger logger = Logger('PurchasedCubit');

class PurchasedCubit extends HydratedCubit<PurchasedState> {
  final InitialPurchasedUsecase _initialPurchasedUsecase;
  final GetProductsUsecase _getProductsUsecase;
  final PurchaseUsecase _purchaseUsecase;
  final ListenToPurchaseErrorsUseCase _listenToPurchaseErrorsUseCase;
  final DisposePurchasedUseCase _disposePurchasedUseCase;
  final ListenToPurchaseUpdatesUseCase _listenToPurchaseUpdatesUseCase;
  final VerifyPurchasedUsecase _verifyPurchasedUsecase;
  final RestorePurchasedUsecase _restorePurchasedUsecase;
  final CompletePurchaseUsecase _completePurchaseUsecase;

  final UserCubit _userCubit;

  StreamSubscription? _errorSubscription;
  StreamSubscription? _purchaseUpdatedSubscription;

  PurchasedCubit({
    required InitialPurchasedUsecase initialPurchasedUsecase,
    required GetProductsUsecase getProductsUsecase,
    required PurchaseUsecase purchaseUsecase,
    required ListenToPurchaseErrorsUseCase listenToPurchaseErrorsUseCase,
    required DisposePurchasedUseCase disposePurchasedUseCase,
    required ListenToPurchaseUpdatesUseCase listenToPurchaseUpdatesUseCase,
    required VerifyPurchasedUsecase verifyPurchasedUsecase,
    required RestorePurchasedUsecase restorePurchasedUsecase,
    required UserCubit userCubit,
    required CompletePurchaseUsecase completePurchaseUsecase,
  }) : _initialPurchasedUsecase = initialPurchasedUsecase,
       _getProductsUsecase = getProductsUsecase,
       _purchaseUsecase = purchaseUsecase,
       _listenToPurchaseErrorsUseCase = listenToPurchaseErrorsUseCase,
       _disposePurchasedUseCase = disposePurchasedUseCase,
       _listenToPurchaseUpdatesUseCase = listenToPurchaseUpdatesUseCase,
       _verifyPurchasedUsecase = verifyPurchasedUsecase,
       _restorePurchasedUsecase = restorePurchasedUsecase,
       _userCubit = userCubit,
       _completePurchaseUsecase = completePurchaseUsecase,
       super(const PurchasedState()) {
    _listenForErrors();
    _listenForPurchaseUpdates();
  }

  void _listenForErrors() {
    // Hủy lắng nghe cũ nếu có (mặc dù thường chỉ gọi 1 lần trong constructor)
    _errorSubscription?.cancel();
    // Gọi use case để lấy stream và bắt đầu lắng nghe
    _errorSubscription = _listenToPurchaseErrorsUseCase().listen(
      (failure) {
        emit(
          state.copyWith(isPurchasing: false, errorMessage: failure.message),
        );
      },
      onError: (error) {
        logger.severe("PurchaseCubit started listening to error stream.");
      },
    );
  }

  void _listenForPurchaseUpdates() {
    _purchaseUpdatedSubscription = _listenToPurchaseUpdatesUseCase().listen((
      purchaseItem,
    ) async {
      final result = await _verifyPurchasedUsecase(
        VerifyPurchasedParams(
          productId: purchaseItem.productId,
          transactionReceipt:
              purchaseItem.purchaseToken.isNotEmpty
                  ? purchaseItem.purchaseToken
                  : purchaseItem.transactionReceipt,
          price: state.purchasingItem?.price ?? 0,
          currency: state.purchasingItem?.currency ?? '',
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(isPurchasing: false, errorMessage: failure.message),
        ),
        (success) async {
          await _completePurchaseUsecase(purchaseItem.transactionId);
          emit(
            state.copyWith(
              isPurchasing: false,
              isVerifyPurchasedSuccess: true,
              isNeedRegister:
                  _userCubit.state.user == null ||
                  _userCubit.state.user?.loginType == LoginType.skip,
            ),
          );
        },
      );
    });
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

  Future<void> purchase(PurchasedPackage package) async {
    try {
      emit(state.copyWith(isPurchasing: true, purchasingItem: package));
      await _purchaseUsecase.call(package);
    } catch (e) {
      emit(state.copyWith(isPurchasing: false));
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(state.copyWith(isPurchasing: true));
      final result = await _restorePurchasedUsecase(NoParams());
      result.fold(
        (failure) => emit(
          state.copyWith(isPurchasing: false, errorMessage: failure.message),
        ),
        (success) => emit(
          state.copyWith(isPurchasing: false, isVerifyPurchasedSuccess: true),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isPurchasing: false, errorMessage: e.toString()));
    }
  }

  void resetStatus() {
    emit(state.copyWith(isResetStatus: true));
  }

  @override
  PurchasedState? fromJson(Map<String, dynamic> json) {
    return PurchasedState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(PurchasedState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _errorSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    _disposePurchasedUseCase();
    return super.close();
  }
}
