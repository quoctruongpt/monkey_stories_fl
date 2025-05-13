import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/account_repository.dart';

class UpdateUserInfoUsecase extends UseCase<Null, UpdateUserInfoUsecaseParams> {
  final AccountRepository accountRepository;

  UpdateUserInfoUsecase({required this.accountRepository});

  @override
  Future<Either<ServerFailureWithCode, Null>> call(
    UpdateUserInfoUsecaseParams params,
  ) async {
    return accountRepository.updateUserInfo(params);
  }
}

class UpdateUserInfoUsecaseParams {
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phone;
  final String? phoneString;

  UpdateUserInfoUsecaseParams({
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.phoneString,
  });
}
