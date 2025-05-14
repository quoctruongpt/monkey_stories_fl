import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/datasources/download/download_remote_data_source.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/data/models/profile/get_profile_response.dart';
import 'package:monkey_stories/data/models/profile/update_profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ApiResponse<ProfileResponseModel?>> updateProfile(
    String? name,
    int? yearOfBirth,
    String? avatarPath,
    String? avatarFilePath,
    int? id,
  );

  Future<ApiResponse<List<GetProfileResponse>>> getListProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final DownloadRemoteDataSource downloadRemoteDataSource;

  ProfileRemoteDataSourceImpl({
    required this.dio,
    required this.downloadRemoteDataSource,
  });

  @override
  Future<ApiResponse<ProfileResponseModel?>> updateProfile(
    String? name,
    int? yearOfBirth,
    String? avatarPath,
    String? avatarFilePath,
    int? id,
  ) async {
    FormData formData;
    if (avatarFilePath != null && avatarFilePath.isNotEmpty) {
      String fileName = avatarFilePath.split('/').last;
      formData = FormData.fromMap({
        'name': name ?? '',
        'year_of_birth': yearOfBirth ?? '',
        'path_avatar': avatarPath ?? '',
        'file_avatar': await MultipartFile.fromFile(
          avatarFilePath,
          filename: fileName,
        ),
        'profile_id': id ?? '',
      });
    } else {
      formData = FormData.fromMap({
        'name': name ?? '',
        'year_of_birth': yearOfBirth ?? '',
        'profile_id': id ?? '',
      });
    }

    final response = await dio.post(ApiEndpoints.updateProfile, data: formData);

    return ApiResponse.fromJsonAsync(response.data, (json, res) async {
      if (json is! Map<String, dynamic>) {
        print(
          'Error: json is not a Map<String, dynamic> or is null in updateProfile',
        );
        return null;
      }
      final String? pathAvatar = json['path_avatar'] as String?;
      String? downloadedAvatarPath;

      if (pathAvatar != null && pathAvatar.isNotEmpty) {
        try {
          downloadedAvatarPath = await downloadRemoteDataSource.downloadImage(
            pathAvatar,
            pathAvatar.split('/').last,
          );
        } catch (error) {
          print('Lỗi tải avatar cho $pathAvatar: $error');
        }
      }
      final profile = ProfileResponseModel.fromJson(<String, dynamic>{
        ...json,
        'local_avatar': downloadedAvatarPath ?? '',
      });
      return profile;
    });
  }

  @override
  Future<ApiResponse<List<GetProfileResponse>>> getListProfile() async {
    final response = await dio.get(ApiEndpoints.getListProfile);

    return ApiResponse.fromJsonAsync(response.data, (json, res) async {
      if (json is Map<String, dynamic>) {
        final list = json['profile_list'] as List?;

        // Sử dụng Future.wait để chờ hoàn thành các hàm async
        final profiles = await Future.wait(
          list?.map<Future<GetProfileResponse>>((e) async {
                final itemMap = e as Map<String, dynamic>;
                final String? pathAvatar = itemMap['path_avatar'] as String?;
                String? downloadedAvatarPath;

                if (pathAvatar != null && pathAvatar.isNotEmpty) {
                  try {
                    downloadedAvatarPath = await downloadRemoteDataSource
                        .downloadImage(pathAvatar, pathAvatar.split('/').last);
                  } catch (error) {
                    print('Lỗi tải avatar cho $pathAvatar: $error');
                  }
                }

                final profile = GetProfileResponse.fromJson(<String, dynamic>{
                  ...itemMap,
                  'local_avatar': downloadedAvatarPath ?? '',
                });
                return profile;
              }).toList() ??
              <Future<GetProfileResponse>>[],
        );

        return profiles;
      }
      return [];
    });
  }
}
