import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class CheckPhoneNumberUsecase extends UseCase<bool, CheckPhoneNumberParams> {
  final AuthRepository _authRepository;

  CheckPhoneNumberUsecase(this._authRepository);

  Future<Either<ServerFailureWithCode, bool>> call(
    CheckPhoneNumberParams params,
  ) async {
    return _authRepository.checkPhoneNumber(
      params.countryCode,
      params.phoneNumber,
    );
  }
}

class CheckPhoneNumberParams {
  final String countryCode;
  final String phoneNumber;

  CheckPhoneNumberParams({
    required this.countryCode,
    required this.phoneNumber,
  });
}
