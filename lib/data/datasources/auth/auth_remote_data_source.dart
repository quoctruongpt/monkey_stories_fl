import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/data/models/auth/account_info_res_model.dart';
import 'package:monkey_stories/data/models/auth/forgot_password_model.dart';
import 'package:monkey_stories/data/models/login_data.dart';
import 'package:monkey_stories/data/models/sign_up_data.dart';
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

  Future<ApiResponse<SignUpResponseData?>> signUp(
    LoginType type,
    String countryCode,
    String phoneNumber,
    String password,
    bool isUpgrade,
  );

  Future<ApiResponse<AccountInfoResModel?>> checkPhoneNumber(
    String countryCode,
    String phoneNumber,
  );

  Future<ApiResponse<Null>> sendOtp(
    ForgotPasswordType type,
    String? countryCode,
    String? phone,
    String? email,
  );

  Future<ApiResponse<VerifyOtpResponseModel?>> verifyOtpWithEmail(
    String otp,
    String email,
  );

  Future<ApiResponse<VerifyOtpResponseModel?>> verifyOtpWithPhone(
    String otp,
    String phone,
    String countryCode,
  );

  Future<ApiResponse<Null>> changePassword(
    String? email,
    String? phone,
    String? countryCode,
    String password,
    String tokenChangePassword,
  );

  Future<ApiResponse<Null>> confirmPassword(
    String password,
    String? newPassword,
  );
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

      return ApiResponse.fromJson(response.data, (json, res) {
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

  @override
  Future<ApiResponse<SignUpResponseData?>> signUp(
    LoginType type,
    String countryCode,
    String phoneNumber,
    String password,
    bool isUpgrade,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.signUp,
        data: {
          'type': type.value,
          'country_code': countryCode,
          'phone': phoneNumber,
          'password': password,
          'is_upgrade': isUpgrade,
        },
      );

      return ApiResponse.fromJson(response.data, (json, res) {
        if (json is Map<String, dynamic>) {
          return SignUpResponseData.fromJson(json);
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
  Future<ApiResponse<AccountInfoResModel?>> checkPhoneNumber(
    String countryCode,
    String phoneNumber,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.checkPhoneNumber,
        data: {'country_code': countryCode, 'phone': phoneNumber},
      );

      return ApiResponse.fromJson(response.data, (json, res) {
        return json is Map<String, dynamic>
            ? AccountInfoResModel.fromJson(json)
            : null;
      });
    } on DioException catch (e) {
      // Các lỗi khác
      throw ServerException(message: e.message ?? 'Dio Error during login');
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      print('kkk $e');
      // Các lỗi khác
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<Null>> sendOtp(
    ForgotPasswordType type,
    String? countryCode,
    String? phone,
    String? email,
  ) async {
    final response = await dioClient.post(
      ApiEndpoints.sendOtp,
      data: {
        'type': type.value,
        'country_code': countryCode ?? '',
        'phone': phone ?? '',
        'email': email ?? '',
      },
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return null;
    });
  }

  @override
  Future<ApiResponse<VerifyOtpResponseModel?>> verifyOtpWithEmail(
    String otp,
    String email,
  ) async {
    final response = await dioClient.post(
      ApiEndpoints.verifyOtpWithEmail,
      data: {'code': otp, 'email': email},
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return VerifyOtpResponseModel.fromJson(json);
    });
  }

  @override
  Future<ApiResponse<VerifyOtpResponseModel?>> verifyOtpWithPhone(
    String otp,
    String phone,
    String countryCode,
  ) async {
    final response = await dioClient.post(
      ApiEndpoints.verifyOtpWithPhone,
      data: {'code': otp, 'phone': phone, 'country_code': countryCode},
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return VerifyOtpResponseModel.fromJson(json);
    });
  }

  @override
  Future<ApiResponse<Null>> changePassword(
    String? email,
    String? phone,
    String? countryCode,
    String password,
    String tokenChangePassword,
  ) async {
    final response = await dioClient.post(
      ApiEndpoints.changePassword,
      data: {
        'email': email ?? '',
        'phone': phone ?? '',
        'country_code': countryCode ?? '',
        'password': password,
        'token_to_change_pw': tokenChangePassword,
      },
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return null;
    });
  }

  @override
  Future<ApiResponse<Null>> confirmPassword(
    String password,
    String? newPassword,
  ) async {
    final response = await dioClient.post(
      ApiEndpoints.confirmPassword,
      data: {'old_password': password, 'new_password': newPassword},
    );

    return ApiResponse.fromJson(response.data, (json, res) {
      return null;
    });
  }
}
