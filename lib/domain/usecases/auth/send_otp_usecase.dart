import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class SendOtpUsecase extends UseCase<String, SendOtpParams> {
  final AuthRepository authRepository;

  SendOtpUsecase(this.authRepository);

  @override
  Future<Either<ServerFailureWithCode, String>> call(
    SendOtpParams params,
  ) async {
    return authRepository.sendOtp(params);
  }
}

class SendOtpParams {
  final String? countryCode;
  final String? phone;
  final String? email;
  final ForgotPasswordType type;

  SendOtpParams({this.countryCode, this.phone, this.email, required this.type});
}
