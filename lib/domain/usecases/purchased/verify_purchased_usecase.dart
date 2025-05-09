import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class VerifyPurchasedUsecase extends UseCase<void, VerifyPurchasedParams> {
  final PurchasedRepository purchasedRepository;

  VerifyPurchasedUsecase(this.purchasedRepository);

  @override
  Future<Either<ServerFailureWithCode, void>> call(
    VerifyPurchasedParams params,
  ) async {
    try {
      final result = await purchasedRepository.verifyPurchase(params);
      if (result.status == ApiStatus.success) {
        return right(null);
      }
      return left(ServerFailureWithCode(message: result.message));
    } catch (e) {
      return left(ServerFailureWithCode(message: e.toString()));
    }
  }
}

class VerifyPurchasedParams {
  final String productId;
  final String transactionReceipt;
  final double price;
  final String currency;

  VerifyPurchasedParams({
    required this.productId,
    required this.transactionReceipt,
    required this.price,
    required this.currency,
  });
}
