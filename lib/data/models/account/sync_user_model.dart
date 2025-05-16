import 'dart:convert';

import 'package:monkey_stories/data/models/setting/schedule.dart';
import 'package:monkey_stories/domain/entities/account/sync_user_entity.dart';

class SyncUserModel {
  final String? languageId;
  final bool? soundtrack;
  final Schedule? schedule;

  SyncUserModel({this.languageId, this.soundtrack, this.schedule});

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
    );
  }

  Map<String, dynamic> toJson() {
    return {'lang': languageId, 'soundtrack': soundtrack};
  }

  SyncUserEntity toEntity() {
    return SyncUserEntity(languageId: languageId, soundtrack: soundtrack);
  }
}
