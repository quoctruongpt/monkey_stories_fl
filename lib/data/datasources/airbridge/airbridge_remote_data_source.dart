import 'package:airbridge_flutter_sdk_restricted/airbridge_flutter_sdk_restricted.dart';

abstract class AirbridgeRemoteDataSource {
  Future<void> registerTokenAirbridge(String token);
  Future<void> setUserInfo(
    String userId,
    String? email,
    String? phone,
    String? name,
  );
}

class AirbridgeRemoteDataSourceImpl implements AirbridgeRemoteDataSource {
  @override
  Future<void> registerTokenAirbridge(String token) async {
    Airbridge.registerPushToken(token);
  }

  @override
  Future<void> setUserInfo(
    String userId,
    String? email,
    String? phone,
    String? name,
  ) async {
    Airbridge.setUserID(userId);
    if (email != null && email.isNotEmpty) {
      Airbridge.setUserEmail(email);
    }
    if (phone != null && phone.isNotEmpty) {
      Airbridge.setUserPhone(phone);
    }
    if (name != null && name.isNotEmpty) {
      Airbridge.setUserAttribute(key: 'name', value: name);
    }
  }
}
