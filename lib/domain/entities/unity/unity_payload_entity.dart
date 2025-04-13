import 'package:monkey_stories/core1/constants/unity_constants.dart';

/// Interface cơ sở cho các loại payload gửi đến Unity
abstract class UnityPayloadEntity {
  const UnityPayloadEntity();

  /// Chuyển payload thành Map để gửi đến Unity
  Map<String, dynamic> toMap();
}

/// Payload chứa thông tin định hướng màn hình
class OrientationPayloadEntity extends UnityPayloadEntity {
  final AppOrientation orientation;

  const OrientationPayloadEntity({required this.orientation});

  @override
  Map<String, dynamic> toMap() {
    return {'orientation': orientation.value};
  }
}

/// Payload chứa thông tin về tiền tệ trong game
class CoinPayloadEntity extends UnityPayloadEntity {
  final String? action;
  final int? amount;

  const CoinPayloadEntity({this.action, this.amount});

  @override
  Map<String, dynamic> toMap() {
    if (action == 'update' && amount != null) {
      return {'action': 'update', 'amount': amount};
    } else {
      return {'action': action};
    }
  }
}

/// Payload chứa thông tin người dùng
class UserPayloadEntity extends UnityPayloadEntity {
  final int userId;
  final String? username;
  final bool isPremium;

  const UserPayloadEntity({
    required this.userId,
    this.username,
    this.isPremium = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'user_id': userId, 'username': username, 'is_premium': isPremium};
  }
}
