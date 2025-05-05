import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class RestorePurchasedUsecase extends UseCase<void, void> {
  final PurchasedRepository _purchasedRepository;

  RestorePurchasedUsecase(this._purchasedRepository);

  @override
  Future<Either<ServerFailure, void>> call(void params) async {
    try {
      await _purchasedRepository.restorePurchase();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
