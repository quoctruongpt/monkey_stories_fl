import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';

class ProfileResponseModel {
  final int id;
  final String? avatarPath;

  ProfileResponseModel({required this.id, this.avatarPath});

  static ProfileResponseModel? fromJson(dynamic json) {
    // Xử lý trường hợp json là mảng rỗng
    if (json is List) {
      return null;
    }

    // Xử lý trường hợp json là Map
    Map<String, dynamic> data = json as Map<String, dynamic>;
    return ProfileResponseModel(
      id: data['profile_id'],
      avatarPath: data['path_avatar'],
    );
  }

  ProfileEntity toEntity(String name, int yearOfBirth) {
    return ProfileEntity(
      id: id,
      name: name,
      yearOfBirth: yearOfBirth,
      avatarPath: avatarPath,
    );
  }
}
