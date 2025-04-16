import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';

class ProfileResponseModel {
  final int id;
  final String? avatarPath;

  ProfileResponseModel({required this.id, this.avatarPath});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      id: json['profile_id'],
      avatarPath: json['path_avatar'],
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
