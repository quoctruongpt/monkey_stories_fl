import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/api_endpoints.dart';
import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:monkey_stories/models/auth/sign_up_data.dart';
import 'package:monkey_stories/core/validators/phone.dart';

final logger = Logger('AuthApiService');

class AuthApiService {
  late final Dio _dio;

  AuthApiService({Dio? dio}) {
    _dio = dio ?? DioConfig.createDio();
  }

  Future<ApiResponse<LoginResponseData?>> login(
    LoginRequestData request,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(response.data, (json) {
      if (json is Map<String, dynamic>) {
        return LoginResponseData.fromJson(json);
      }
      return null;
    });
  }

  Future<ApiResponse<dynamic>> checkPhoneNumber(
    PhoneNumberInput phoneNumber,
    CancelToken? cancelToken,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.checkPhoneNumber,
        data: {
          'country_code': phoneNumber.countryCode,
          'phone': phoneNumber.phoneNumber,
        },
        cancelToken: cancelToken,
      );

      return ApiResponse.fromJson(response.data, (json) {
        return null;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SignUpResponseData?>> signUp(
    SignUpRequestData request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signUp,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(response.data, (json) {
        logger.info(json is Map<String, dynamic>);
        if (json is Map<String, dynamic>) {
          return SignUpResponseData.fromJson(json);
        }
        return null;
      });
    } catch (e) {
      logger.severe(e.toString());
      rethrow;
    }
  }
}
