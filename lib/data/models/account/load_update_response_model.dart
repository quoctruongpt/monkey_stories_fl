import 'package:monkey_stories/data/models/account/user_model.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';

class LoadUpdateResponseModel {
  final User userInfo;

  LoadUpdateResponseModel({required this.userInfo});

  factory LoadUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return LoadUpdateResponseModel(userInfo: User.fromJson(json['userInfo']));
  }

  Map<String, dynamic> toJson() {
    return {'userInfo': userInfo.toJson()};
  }

  LoadUpdateEntity toEntity() {
    return LoadUpdateEntity(user: userInfo.toEntity());
  }
}
