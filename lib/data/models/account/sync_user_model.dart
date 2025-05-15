import 'package:monkey_stories/domain/entities/account/sync_user_entity.dart';

class SyncUserModel {
  final String? languageId;
  final bool? soundtrack;

  SyncUserModel({this.languageId, this.soundtrack});

  factory SyncUserModel.fromJson(Map<String, dynamic> json) {
    return SyncUserModel(
      languageId: json['lang'],
      soundtrack: json['soundtrack'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'lang': languageId, 'soundtrack': soundtrack};
  }

  SyncUserEntity toEntity() {
    return SyncUserEntity(languageId: languageId, soundtrack: soundtrack);
  }
}
