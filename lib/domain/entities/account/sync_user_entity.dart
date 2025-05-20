class SyncUserEntity {
  final String? languageId;
  final bool? soundtrack;
  final SyncUserProfilesEntity? profiles;

  SyncUserEntity({this.languageId, this.soundtrack, this.profiles});
}

class SyncUserProfilesEntity {
  final List<SyncUserProfileEntity> profiles;

  SyncUserProfilesEntity({required this.profiles});

  factory SyncUserProfilesEntity.fromJson(Map<String, dynamic> json) {
    return SyncUserProfilesEntity(
      profiles:
          json['profiles']
              .map((e) => SyncUserProfileEntity.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'profiles': profiles.map((e) => e.toJson()).toList()};
  }

  SyncUserProfilesEntity copyWith({List<SyncUserProfileEntity>? profiles}) {
    return SyncUserProfilesEntity(profiles: profiles ?? this.profiles);
  }
}

class SyncUserProfileEntity {
  final int numberChangeAge;
  final int id;

  SyncUserProfileEntity({required this.numberChangeAge, required this.id});

  factory SyncUserProfileEntity.fromJson(Map<String, dynamic> json) {
    return SyncUserProfileEntity(
      numberChangeAge: json['numberChangeAge'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'numberChangeAge': numberChangeAge, 'id': id};
  }

  SyncUserProfileEntity copyWith({int? numberChangeAge}) {
    return SyncUserProfileEntity(
      numberChangeAge: numberChangeAge ?? this.numberChangeAge,
      id: id,
    );
  }
}
