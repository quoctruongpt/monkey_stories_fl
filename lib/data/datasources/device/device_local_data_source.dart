import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart'; // Assuming SharedPrefKeys is exported here
import 'package:monkey_stories/core/error/exceptions.dart';

abstract class DeviceLocalDataSource {
  Future<String?> getDeviceId();
  Future<void> cacheDeviceId(String deviceId);
}

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final SharedPreferences sharedPreferences;

  DeviceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getDeviceId() async {
    try {
      return sharedPreferences.getString(SharedPrefKeys.deviceId);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDeviceId(String deviceId) async {
    try {
      await sharedPreferences.setString(SharedPrefKeys.deviceId, deviceId);
    } catch (e) {
      throw CacheException();
    }
  }
}
