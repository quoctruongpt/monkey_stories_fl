import 'package:airbridge_flutter_sdk_restricted/airbridge_flutter_sdk_restricted.dart';

abstract class TrackingRemoteDataSource {
  Future<void> registerTokenAirbridge(String token);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  @override
  Future<void> registerTokenAirbridge(String token) async {
    Airbridge.registerPushToken(token);
  }
}
