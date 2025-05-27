class ProfileEntity {
  final int id;
  final String name;
  final int yearOfBirth;
  final String? avatarPath;
  final String? localAvatarPath;
  final int? levelId;
  final int numberChangeAge;
  final int timeCreated;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.yearOfBirth,
    this.avatarPath,
    this.localAvatarPath,
    this.levelId,
    this.numberChangeAge = 0,
    this.timeCreated = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatarPath,
      'local_avatar': localAvatarPath,
      'year_of_birth': yearOfBirth,
      'level_id': levelId,
      'number_change_age': numberChangeAge,
      'time_created': timeCreated,
    };
  }

  static ProfileEntity fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'],
      name: json['name'],
      avatarPath: json['path_avatar'],
      localAvatarPath: json['local_avatar'],
      yearOfBirth: json['year_of_birth'],
      levelId: json['level_id'],
      numberChangeAge: json['number_change_age'],
      timeCreated: json['time_created'],
    );
  }
}
