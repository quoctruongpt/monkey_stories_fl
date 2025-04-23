import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class InitialPurchasedUsecase extends UseCase<void, NoParams> {
  final PurchasedRepository repository;

  InitialPurchasedUsecase(this.repository);

  @override
  Future<Either<ServerFailure, void>> call(NoParams params) async {
    try {
      await repository.initialPurchased();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
