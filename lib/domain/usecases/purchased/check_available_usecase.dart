// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class CheckAvailableUsecase {
  final PurchasedRepository _purchasedRepository;

  CheckAvailableUsecase(this._purchasedRepository);

  Future<Either<Failure, bool>> call() async {
    try {
      final result = await _purchasedRepository.isInappPurchaseAvailable();
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
