import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';

class GetLoadUpdateUsecase extends UseCase<void, bool> {
  final AccountRepository accountRepository;

  GetLoadUpdateUsecase(this.accountRepository);

  @override
  Future<Either<Failure, LoadUpdateEntity?>> call(
    bool showConnectionErrorDialog,
  ) async {
    return accountRepository.loadUpdate(
      showConnectionErrorDialog: showConnectionErrorDialog,
    );
  }
}
