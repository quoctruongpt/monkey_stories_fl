import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/domain/entities/unity/unity_payload_entity.dart';

/// Interface cơ sở cho các model payload
abstract class UnityPayloadModel {
  /// Chuyển model thành Map để serialization
  Map<String, dynamic> toJson();
}

/// Model biểu diễn thông tin định hướng màn hình
class OrientationPayloadModel extends UnityPayloadModel {
  final AppOrientation orientation;

  OrientationPayloadModel({required this.orientation});

  /// Tạo model từ entity
  factory OrientationPayloadModel.fromEntity(OrientationPayloadEntity entity) {
    return OrientationPayloadModel(orientation: entity.orientation);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'orientation': orientation.value};
  }
}

/// Model biểu diễn thông tin coin
class CoinPayloadModel extends UnityPayloadModel {
  final String? action;
  final int? amount;

  CoinPayloadModel({this.action, this.amount});

  /// Tạo model từ entity
  factory CoinPayloadModel.fromEntity(CoinPayloadEntity entity) {
    return CoinPayloadModel(action: entity.action, amount: entity.amount);
  }

  @override
  Map<String, dynamic> toJson() {
    if (action == 'update' && amount != null) {
      return {'action': 'update', 'amount': amount};
    } else {
      return {'action': action};
    }
  }
}

/// Model biểu diễn thông tin người dùng
class UserPayloadModel extends UnityPayloadModel {
  final int userId;
  final String? username;
  final bool isPremium;

  UserPayloadModel({
    required this.userId,
    this.username,
    this.isPremium = false,
  });

  /// Tạo model từ entity
  factory UserPayloadModel.fromEntity(UserPayloadEntity entity) {
    return UserPayloadModel(
      userId: entity.userId,
      username: entity.username,
      isPremium: entity.isPremium,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'username': username, 'is_premium': isPremium};
  }
}
