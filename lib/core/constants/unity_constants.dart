/// Các đối tượng Unity trong game
class UnityGameObjects {
  static const String reactNativeBridge = 'AppUnityBridge';
}

/// Tên các phương thức sử dụng khi giao tiếp với Unity
class UnityMethodNames {
  static const String requestUnityAction = 'SendToUnity';
  static const String resultFromUnity = 'OnResultFromUnity';
}

/// Các loại tin nhắn được hỗ trợ trong ứng dụng
class MessageTypes {
  static const String orientation = 'orientation';
  static const String openUnity = 'open_unity';
  static const String closeUnity = 'CloseUnity';
  static const String coin = 'coin';
  static const String user = 'user';
  static const String openListProfile = 'open_list_profile';
  static const String buyNow = 'buy_now';
  static const String goToPurchase = 'go_to_purchase';
}

class Orientation {
  static final String portrait = 'PORTRAIT';
  static final String landscapeLeft = 'LANDSCAPE-LEFT';
  static final String landscapeRight = 'LANDSCAPE-RIGHT';
}

/// Định nghĩa các hướng màn hình được hỗ trợ trong ứng dụng
enum AppOrientation {
  portrait('PORTRAIT'),
  landscapeLeft('LANDSCAPE-LEFT'),
  landscapeRight('LANDSCAPE-RIGHT');

  final String value;
  const AppOrientation(this.value);

  static AppOrientation fromValue(int value) {
    return AppOrientation.values.firstWhere(
      (o) => o.value == value,
      orElse: () => AppOrientation.portrait,
    );
  }
}

/// Trạng thái kết quả từ Unity
enum ResultStatus {
  success(true),
  failure(false);

  final bool value;
  const ResultStatus(this.value);
}
