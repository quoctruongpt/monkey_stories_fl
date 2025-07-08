// Dart imports:
import 'dart:io';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:monkey_stories/core/error/exceptions.dart';

import 'package:monkey_stories/core/constants/constants.dart'; // Assuming SharedPrefKeys is exported here

abstract class DeviceLocalDataSource {
  Future<String?> getDeviceId();
  Future<void> cacheDeviceId(String deviceId);
  Future<Map<String, String>> getDeviceInfo();
}

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final SharedPreferences sharedPreferences;
  Map<String, String>? _deviceInfoCache;

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

  @override
  Future<Map<String, String>> getDeviceInfo() async {
    if (_deviceInfoCache != null) {
      return _deviceInfoCache!;
    }
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    String deviceType = 'mobile';
    String osName = '';
    String osVersion = '';
    final platform = Platform.isAndroid ? 'Android' : 'iOS';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      osName = 'Android';
      osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      osName = 'iOS';
      osVersion = iosInfo.systemVersion;
      if (iosInfo.model.toLowerCase().contains('ipad')) {
        deviceType = 'tablet';
        osName = 'iPadOS';
      }
    }

    final deviceInfo = {
      'deviceType': deviceType,
      'platform': platform,
      'osName': osName,
      'osVersion': osVersion,
      'appVersion': packageInfo.version,
    };
    _deviceInfoCache = deviceInfo;
    return deviceInfo;
  }
}
