class UnityGameObjects {
  static const String reactNativeBridge = 'AppUnityBridge';
}

class UnityMethodNames {
  static const String requestUnityAction = 'SendToUnity';
  static const String resultFromUnity = 'OnResultFromUnity';
}

class MessageTypes {
  static const String orientation = 'orientation';
  static const String openUnity = 'open_unity';
  static const String closeUnity = 'CloseUnity';
  static const String coin = 'coin';
  static const String user = 'user';
}

enum ResultStatus {
  success(true),
  failure(false);

  final bool value;
  const ResultStatus(this.value);
}
