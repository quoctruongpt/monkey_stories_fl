import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';

class GetProfileResponse {
  final int id;
  final String name;
  final String avatar;
  final int yearOfBirth;
  final int levelId;

  GetProfileResponse({
    required this.id,
    required this.name,
    required this.avatar,
    required this.yearOfBirth,
    required this.levelId,
  });

  static GetProfileResponse fromJson(dynamic json) {
    return GetProfileResponse(
      id: json['id'],
      name: json['name'],
      avatar: json['path_avatar'] ?? '',
      yearOfBirth: json['year_of_birth'],
      levelId: json['level_id'],
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      avatarPath: avatar,
      yearOfBirth: yearOfBirth,
      levelId: levelId,
    );
  }
}
