import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class PurchaseUsecase extends UseCase<void, PurchasedPackage> {
  final PurchasedRepository _purchasedRepository;

  PurchaseUsecase(this._purchasedRepository);

  @override
  Future<Either<ServerFailure, void>> call(PurchasedPackage package) async {
    try {
      await _purchasedRepository.purchase(package);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
