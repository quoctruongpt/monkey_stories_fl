import 'package:monkey_stories/data/models/account/location_model.dart';
import 'package:monkey_stories/data/models/account/user_model.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';

class LoadUpdateResponseModel {
  final User userInfo;
  final LocationModel location;

  LoadUpdateResponseModel({required this.userInfo, required this.location});

  factory LoadUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return LoadUpdateResponseModel(
      userInfo: User.fromJson(json['userInfo']),
      location: LocationModel.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userInfo': userInfo.toJson(), 'location': location.toJson()};
  }

  LoadUpdateEntity toEntity() {
    return LoadUpdateEntity(user: userInfo.toEntity());
  }
}
