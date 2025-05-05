import 'package:monkey_stories/core/constants/app_constants.dart';
import 'package:monkey_stories/data/models/account/location_model.dart';
import 'package:monkey_stories/data/models/account/purchased_info_model.dart';
import 'package:monkey_stories/data/models/account/user_model.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';

class LoadUpdateResponseModel {
  final User userInfo;
  final LocationModel location;
  final PurchasedInfoModel purchasedInfo;

  LoadUpdateResponseModel({
    required this.userInfo,
    required this.location,
    required this.purchasedInfo,
  });

  factory LoadUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    final purchasedRaw = json['purchased'];
    Map<String, dynamic>? purchasedMap;

    if (purchasedRaw is Map<String, dynamic>) {
      purchasedMap = purchasedRaw;
    }

    return LoadUpdateResponseModel(
      userInfo: User.fromJson(json['userInfo']),
      location: LocationModel.fromJson(json['location']),
      purchasedInfo: PurchasedInfoModel.fromJson(
        purchasedMap?[AppConstants.courseId.toString()],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userInfo': userInfo.toJson(),
      'location': location.toJson(),
      'purchasedInfo': purchasedInfo.toJson(),
    };
  }

  LoadUpdateEntity toEntity() {
    return LoadUpdateEntity(
      user: userInfo.toEntity(),
      purchasedInfo: purchasedInfo.toEntity(),
    );
  }
}
