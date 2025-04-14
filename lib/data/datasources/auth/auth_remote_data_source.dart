import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<LoginResponseData?>> login(
    LoginType loginType,
    String? phone,
    String? email,
    String? password,
    String? token,
    String? name,
  );

  Future<Map<String, dynamic>?> getUserFacebook();

  Future<AccessToken?> getOldFacebookToken();

  Future<GoogleSignInAccount?> getUserGoogle();

  Future<CredentialState?> getCredentialStateApple(String appleId);
}

final logger = Logger('DeviceRemoteDataSourceImpl');
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ApiResponse<LoginResponseData?>> login(
    LoginType loginType,
    String? phone,
    String? email,
    String? password,
    String? token,
    String? name,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data:
            LoginRequestData(
              loginType: loginType,
              phone: phone,
              email: email,
              password: password,
              token: token,
              name: name,
            ).toJson(),
      );

      return ApiResponse.fromJson(response.data, (json) {
        if (json is Map<String, dynamic>) {
          return LoginResponseData.fromJson(json);
        }
        return null;
      });
    } on DioException catch (e) {
      // Các lỗi khác
      throw ServerException(message: e.message ?? 'Dio Error during login');
    } catch (e) {
      // Các lỗi khác
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserFacebook() async {
    return FacebookAuth.instance.getUserData();
  }

  @override
  Future<AccessToken?> getOldFacebookToken() async {
    return FacebookAuth.instance.accessToken;
  }

  @override
  Future<GoogleSignInAccount?> getUserGoogle() async {
    return _googleSignIn.signInSilently();
  }

  @override
  Future<CredentialState?> getCredentialStateApple(String appleId) async {
    return SignInWithApple.getCredentialState(appleId);
  }
}
