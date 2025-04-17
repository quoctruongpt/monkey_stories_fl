import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/auth/verify_otp_entity.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase extends UseCase<void, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUsecase(this.authRepository);

  @override
  Future<Either<ServerFailureWithCode, VerifyOtpEntity>> call(
    VerifyOtpParams params,
  ) async {
    return authRepository.verifyOtp(params);
  }
}

class VerifyOtpParams {
  final String otp;
  final String? email;
  final String? countryCode;
  final String? phone;
  final ForgotPasswordType type;

  VerifyOtpParams({
    required this.otp,
    this.email,
    this.countryCode,
    this.phone,
    required this.type,
  });
}
