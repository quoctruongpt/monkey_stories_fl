import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/login_with_last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/user_sosial_entity.dart';

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
    String countryCode,
    String phoneNumber,
    String password,
  );

  Future<Either<ServerFailureWithCode, bool>> checkPhoneNumber(
    String countryCode,
    String phoneNumber,
  );

  Future<Either<Failure, void>> logout();
}
