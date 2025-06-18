import 'package:monkey_stories/core/constants/app_constants.dart';
import 'package:monkey_stories/data/models/account/location_model.dart';
import 'package:monkey_stories/data/models/account/purchased_info_model.dart';
import 'package:monkey_stories/data/models/account/sync_user_model.dart';
import 'package:monkey_stories/data/models/account/user_model.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';

class LoadUpdateResponseModel {
  final User userInfo;
  final LocationModel location;
  final PurchasedInfoModel purchasedInfo;
  final SyncUserModel syncUser;

  LoadUpdateResponseModel({
    required this.userInfo,
    required this.location,
    required this.purchasedInfo,
    required this.syncUser,
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
      syncUser: SyncUserModel.fromJson(json['sync_user']['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userInfo': userInfo.toJson(),
      'location': location.toJson(),
      'purchasedInfo': purchasedInfo.toJson(),
      'syncUser': syncUser.toJson(),
    };
  }

  LoadUpdateEntity toEntity() {
    return LoadUpdateEntity(
      user: userInfo.toEntity(),
      purchasedInfo: purchasedInfo.toEntity(),
      syncUser: syncUser.toEntity(),
    );
  }
}
