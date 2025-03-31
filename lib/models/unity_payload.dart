import 'package:monkey_stories/models/orientation.dart';

abstract class UnityPayload {
  Map<String, dynamic> toJson();
}

class OrientationPayload extends UnityPayload {
  AppOrientation orientation;

  OrientationPayload({required this.orientation});

  @override
  Map<String, dynamic> toJson() {
    return {'orientation': orientation.value};
  }
}

class CoinPayload extends UnityPayload {
  final String? action;
  final int? amount;

  CoinPayload({this.action, this.amount});

  @override
  Map<String, dynamic> toJson() {
    if (action == 'update' && amount != null) {
      return {'action': 'update', 'amount': amount};
    } else {
      return {'action': action};
    }
  }
}
