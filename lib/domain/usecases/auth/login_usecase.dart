import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class LoginUsecase implements UseCase<bool, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<ServerFailureWithCode, bool>> call(LoginParams params) async {
    return await repository.login(
      params.loginType,
      params.phone,
      params.email,
      params.password,
    );
  }
}

class LoginParams extends Equatable {
  final LoginType loginType;
  final String? phone;
  final String? email;
  final String? password;

  const LoginParams({
    required this.loginType,
    this.phone,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [loginType, phone, email, password];
}
