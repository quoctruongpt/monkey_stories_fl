import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/api_endpoints.dart';
import 'package:monkey_stories/data/models/api_response.dart';

abstract class SettingsRemoteDataSource {
  Future<ApiResponse<Null>> updateUserSetting({
    bool? isBackgroundMusicEnabled,
    bool? isNotificationEnabled,
    String? languageId,
  });
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio dio;

  SettingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<Null>> updateUserSetting({
    bool? isBackgroundMusicEnabled,
    bool? isNotificationEnabled,
    String? languageId,
  }) async {
    final params = {
      'soundtrack': isBackgroundMusicEnabled,
      'lang-setting': languageId,
    };

    final response = await dio.post(ApiEndpoints.settingUser, data: params);

    return ApiResponse.fromJson(response.data, (json, res) => null);
  }
}
