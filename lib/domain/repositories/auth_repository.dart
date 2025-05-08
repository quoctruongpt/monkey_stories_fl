import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/active_license/account_info.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/login_with_last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/user_sosial_entity.dart';
import 'package:monkey_stories/domain/entities/auth/verify_otp_entity.dart';
import 'package:monkey_stories/domain/usecases/auth/change_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';

abstract class AuthRepository {
  // Trả về true nếu đã đăng nhập, false nếu chưa
  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<ServerFailureWithCode, bool>> login(
    LoginType loginType,
    String? phone,
    String? email,
    String? password,
  );

  Future<Either<ServerFailureWithCode, bool>> loginWithLastLogin(
    LoginWithLastLoginEntity params,
  );

  Future<Either<Failure, LastLoginEntity?>> getLastLogin();

  Future<Either<Failure, UserSocialEntity?>> getUserSocial(LoginType type);

  Future<Either<ServerFailureWithCode, bool>> signUp(
    String? countryCode,
    String? phoneNumber,
    String? password,
    LoginType signUpType,
    bool isUpgrade,
  );

  Future<Either<ServerFailureWithCode<AccountInfoEntity?>, bool>>
  checkPhoneNumber(String countryCode, String phoneNumber);

  Future<Either<Failure, void>> logout();

  Future<Either<ServerFailureWithCode, String>> sendOtp(SendOtpParams params);

  Future<Either<ServerFailureWithCode, VerifyOtpEntity>> verifyOtp(
    VerifyOtpParams params,
  );

  Future<Either<Failure, void>> changePassword(ChangePasswordParams params);

  Future<Either<Failure, void>> cacheDataLogin({
    required String accessToken,
    required String refreshToken,
    required LoginType loginType,
    String? phone,
    String? email,
    required bool isSocial,
  });
}
