import 'dart:convert';

import 'package:monkey_stories/data/models/setting/schedule.dart';
import 'package:monkey_stories/domain/entities/account/sync_user_entity.dart';

class SyncUserModel {
  final String? languageId;
  final bool? soundtrack;
  final Schedule? schedule;
  final SyncUserProfilesModel? profiles;

  SyncUserModel({
    this.languageId,
    this.soundtrack,
    this.schedule,
    this.profiles,
  });

  factory SyncUserModel.fromJson(Map<String, dynamic> json) {
    final weekdaysSchedule =
        json['schedule']['day_of_week'] is List
            ? []
            : jsonDecode(json['schedule']['day_of_week']);

    final timeSchedule = jsonDecode(json['schedule']['time']);

    return SyncUserModel(
      languageId: json['lang'],
      soundtrack: json['soundtrack'],
      schedule:
          weekdaysSchedule.length > 0 &&
                  timeSchedule['hour'] != null &&
                  timeSchedule['minute'] != null
              ? Schedule.fromJson(json['schedule'])
              : null,
      profiles:
          json['profile'] is Map<String, dynamic>
              ? SyncUserProfilesModel.fromJson(json['profile'])
              : SyncUserProfilesModel(profiles: []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lang': languageId, 'soundtrack': soundtrack};
  }

  SyncUserEntity toEntity() {
    return SyncUserEntity(
      languageId: languageId,
      soundtrack: soundtrack,
      profiles: SyncUserProfilesEntity(
        profiles: profiles?.profiles.map((e) => e.toEntity()).toList() ?? [],
      ),
    );
  }
}

class SyncUserProfilesModel {
  final List<SyncUserProfileModel> profiles;

  SyncUserProfilesModel({required this.profiles});

  factory SyncUserProfilesModel.fromJson(Map<String, dynamic> json) {
    return SyncUserProfilesModel(
      profiles:
          json.keys
              .map(
                (profileId) => SyncUserProfileModel.fromJson(
                  int.parse(profileId),
                  json[profileId]!,
                ),
              )
              .toList(),
    );
  }
}

class SyncUserProfileModel {
  final int numberChangeAge;
  final int id;

  SyncUserProfileModel({required this.numberChangeAge, required this.id});

  factory SyncUserProfileModel.fromJson(int id, Map<String, dynamic> json) {
    return SyncUserProfileModel(numberChangeAge: json['change_age'], id: id);
  }

  SyncUserProfileEntity toEntity() {
    return SyncUserProfileEntity(numberChangeAge: numberChangeAge, id: id);
  }
}
