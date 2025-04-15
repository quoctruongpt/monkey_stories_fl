import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
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
    );
  }
}

class SignUpParams extends Equatable {
  final String countryCode;
  final String phoneNumber;
  final String password;

  const SignUpParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [countryCode, phoneNumber, password];
}
