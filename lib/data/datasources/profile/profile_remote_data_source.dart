import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/data/models/profile/update_profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ApiResponse<ProfileResponseModel?>> updateProfile(
    String name,
    int yearOfBirth,
    String? avatarPath,
    String? avatarFile,
    int? id,
  );
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<ProfileResponseModel?>> updateProfile(
    String name,
    int yearOfBirth,
    String? avatarPath,
    String? avatarFile,
    int? id,
  ) async {
    final response = await dio.post(
      ApiEndpoints.updateProfile,
      data: {
        'name': name,
        'year_of_birth': yearOfBirth,
        'path_avatar': avatarPath ?? '',
        // 'file_avatar': avatarFile,
        'profile_id': id ?? '',
      },
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => ProfileResponseModel.fromJson(json),
    );
  }
}
