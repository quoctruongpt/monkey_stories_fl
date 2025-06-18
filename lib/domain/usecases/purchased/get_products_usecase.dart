import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class GetProductsUsecase extends UseCase<List<PurchasedPackage>, NoParams> {
  final PurchasedRepository repository;

  GetProductsUsecase(this.repository);

  @override
  Future<Either<ServerFailure, List<PurchasedPackage>>> call(
    NoParams params,
  ) async {
    try {
      final products = await repository.getProducts(Purchase.packages);
      return right(products);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
