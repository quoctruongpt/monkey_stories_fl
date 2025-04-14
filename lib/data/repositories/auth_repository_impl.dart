import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_remote_data_source.dart';
import 'package:monkey_stories/data/models/auth/last_login_model.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/login_with_last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/user_sosial_entity.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final result = await localDataSource.isLoggedIn();
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, LastLoginEntity?>> getLastLogin() async {
    try {
      final result = await localDataSource.getLastLogin();
      // logger.info('lastLogin: ${result?.loginType}');
      return Right(result?.toEntity());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<ServerFailureWithCode, bool>> login(
    LoginType loginType,
    String? phone,
    String? email,
    String? password,
  ) async {
    String? token;
    String? name;
    String? email0 = email;

    switch (loginType) {
      case LoginType.email:
        if (password == null) {
          final socialLoginData = await _loginWithGoogle();
          token = socialLoginData.token;
          name = socialLoginData.name;
          email0 = socialLoginData.email;
        }
        break;
      case LoginType.facebook:
        final socialLoginData = await _loginWithFacebook();
        token = socialLoginData.token;
        name = socialLoginData.name;
        email0 = socialLoginData.email;
        break;
      case LoginType.apple:
        final socialLoginData = await _loginWithApple();
        token = socialLoginData.token;
        name = socialLoginData.name;
        email0 = socialLoginData.email;
        break;
      default:
        break;
    }

    // logger.info('login: $email');

    return _callApiLogin(loginType, phone, email0, password, token, name);
  }

  @override
  Future<Either<ServerFailureWithCode, bool>> loginWithLastLogin(
    LoginWithLastLoginEntity params,
  ) async {
    return _callApiLogin(
      params.loginType,
      null,
      params.email,
      null,
      params.token,
      null,
    );
  }

  @override
  Future<Either<ServerFailureWithCode, bool>> signUp(
    String countryCode,
    String phoneNumber,
    String password,
  ) async {
    final result = await remoteDataSource.signUp(
      LoginType.phone,
      countryCode,
      phoneNumber,
      password,
    );

    if (result.status == ApiStatus.success) {
      await localDataSource.cacheToken(result.data?.accessToken ?? '');
      await localDataSource.cacheRefreshToken(result.data?.refreshToken ?? '');
      await localDataSource.cacheLastLogin(
        LastLoginModel(
          loginType: LoginType.phone,
          phone: '$countryCode$phoneNumber',
          isSocial: false,
        ),
      );

      return const Right(true);
    }

    return Left(
      ServerFailureWithCode(message: result.message, code: result.code),
    );
  }

  @override
  Future<Either<ServerFailureWithCode, bool>> checkPhoneNumber(
    String countryCode,
    String phoneNumber,
  ) async {
    final result = await remoteDataSource.checkPhoneNumber(
      countryCode,
      phoneNumber,
    );

    if (result.status == ApiStatus.success) {
      return const Right(true);
    }

    return Left(
      ServerFailureWithCode(message: result.message, code: result.code),
    );
  }

  Future<Either<ServerFailureWithCode, bool>> _callApiLogin(
    LoginType loginType,
    String? phone,
    String? email,
    String? password,
    String? token,
    String? name,
  ) async {
    final result = await remoteDataSource.login(
      loginType,
      phone,
      email,
      password,
      token,
      name,
    );

    if (result.status == ApiStatus.success) {
      await localDataSource.cacheToken(result.data?.accessToken ?? '');
      await localDataSource.cacheRefreshToken(result.data?.refreshToken ?? '');
      await localDataSource.cacheLastLogin(
        LastLoginModel(
          loginType: loginType,
          phone: phone,
          email: email,
          isSocial: password == null,
        ),
      );

      return const Right(true);
    }

    return Left(
      ServerFailureWithCode(message: result.message, code: result.code),
    );
  }

  Future<SocialLoginData> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerFailure(message: 'Người dùng đã huỷ đăng nhập');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final token = googleAuth.accessToken;
      final request = SocialLoginData(
        token: token ?? '',
        name: googleUser.displayName ?? '',
        email: googleUser.email,
      );
      return request;
    } catch (e) {
      throw const ServerFailure(message: 'Đăng nhập thất bại');
    }
  }

  Future<SocialLoginData> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email'],
      );
      if (result.status == LoginStatus.success) {
        final token = (result.accessToken?.tokenString ?? '');
        String name = '';
        String email = '';
        final userData = await getUserFacebook();
        userData.fold(
          (failure) {
            name = '';
          },
          (userData) {
            name = userData?['name'] ?? '';
            email = userData?['email'] ?? '';
          },
        );

        final request = SocialLoginData(token: token, name: name, email: email);
        return request;
      } else {
        throw const ServerFailure(message: 'Đăng nhập thất bại');
      }
    } catch (e) {
      throw const ServerFailure(message: 'Đăng nhập thất bại');
    }
  }

  Future<SocialLoginData> _loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final token = credential.identityToken;

      final request = SocialLoginData(
        token: token ?? '',
        name: credential.givenName ?? 'Apple',
        appleUserIdentifier: credential.userIdentifier,
        email: credential.email,
      );
      return request;
    } catch (e) {
      throw const ServerFailure(message: 'Đăng nhập thất bại');
    }
  }

  Future<Either<Failure, Map<String, dynamic>?>> getUserFacebook() async {
    try {
      final userData = await FacebookAuth.instance.getUserData();
      return Right(userData);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Lấy thông tin người dùng thất bại'),
      );
    }
  }

  Future<Either<Failure, AccessToken?>> getOldFacebookToken() async {
    try {
      final token = await FacebookAuth.instance.accessToken;
      return Right(token);
    } catch (e) {
      return const Left(ServerFailure(message: 'Lấy token thất bại'));
    }
  }

  Future<Either<Failure, GoogleSignInAccount?>> getUserGoogle() async {
    try {
      final googleUser = await _googleSignIn.signInSilently();
      return Right(googleUser);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Lấy tài khoản Google thất bại'),
      );
    }
  }

  Future<Either<Failure, CredentialState?>> getCredentialStateApple(
    String appleId,
  ) async {
    try {
      final credentialState = await SignInWithApple.getCredentialState(appleId);
      return Right(credentialState);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Lấy trạng thái xác thực Apple thất bại'),
      );
    }
  }

  @override
  Future<Either<Failure, UserSocialEntity?>> getUserSocial(
    LoginType type,
  ) async {
    try {
      switch (type) {
        case LoginType.facebook:
          final userData = await remoteDataSource.getUserFacebook();
          final facebookToken = await remoteDataSource.getOldFacebookToken();

          final userSocial = UserSocialEntity(
            token: facebookToken?.tokenString ?? '',
            name: userData?['name'] ?? '',
            email: userData?['email'] ?? '',
          );
          return Right(userSocial);
        case LoginType.email:
          final userGoogle = await remoteDataSource.getUserGoogle();
          final googleAuth = await userGoogle?.authentication;

          final userSocial = UserSocialEntity(
            token: googleAuth?.accessToken,
            name: userGoogle?.displayName ?? '',
            email: userGoogle?.email ?? '',
          );
          return Right(userSocial);
        case LoginType.apple:
          final lastLogin = await localDataSource.getLastLogin();
          if (lastLogin?.appleUserCredential == null) {
            throw ('no info');
          }

          final credentialState = await remoteDataSource
              .getCredentialStateApple(
                lastLogin?.appleUserCredential as String,
              );
          if (credentialState == CredentialState.authorized) {
            final userSocial = UserSocialEntity(
              token: lastLogin?.token,
              email: '',
              name: '',
            );
            return Right(userSocial);
          } else {
            throw ('logout');
          }

        default:
          return const Right(null);
      }
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Lấy thông tin người dùng thất bại'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAllData();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(message: 'Đăng xuất thất bại'));
    }
  }
}

class SocialLoginData {
  final String token;
  final String name;
  final String? email;
  final String? appleUserIdentifier;

  SocialLoginData({
    required this.token,
    required this.name,
    this.email,
    this.appleUserIdentifier,
  });
}
