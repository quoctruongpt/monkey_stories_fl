import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class SignUpUsecase extends UseCase<bool, SignUpParams> {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  @override
  Future<Either<ServerFailureWithCode, bool>> call(SignUpParams params) async {
    return repository.signUp(
      params.countryCode,
      params.phoneNumber,
      params.password,
      LoginType.phone,
      params.isUpgrade,
    );
  }
}

class SignUpParams extends Equatable {
  final String countryCode;
  final String phoneNumber;
  final String password;
  final bool isUpgrade;

  const SignUpParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    this.isUpgrade = false,
  });

  @override
  List<Object?> get props => [countryCode, phoneNumber, password];
}
