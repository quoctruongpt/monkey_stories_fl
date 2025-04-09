import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/network/api_endpoints.dart';
import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';

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
}
