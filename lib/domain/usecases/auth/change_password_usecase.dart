import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class ChangePasswordUsecase extends UseCase<void, ChangePasswordParams> {
  final AuthRepository _authRepository;

  ChangePasswordUsecase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return _authRepository.changePassword(params);
  }
}

class ChangePasswordParams {
  final String? email;
  final String? phone;
  final String? countryCode;
  final String password;
  final String tokenChangePassword;

  ChangePasswordParams({
    this.email,
    this.phone,
    this.countryCode,
    required this.password,
    required this.tokenChangePassword,
  });
}
