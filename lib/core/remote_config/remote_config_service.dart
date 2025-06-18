import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:monkey_stories/core/constants/remote_config.dart';
import 'package:logging/logging.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  final Logger _logger = Logger('RemoteConfigService');

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Đặt các giá trị mặc định. Bạn nên tạo một map chứa tất cả các giá trị mặc định ở đây.
    await _remoteConfig.setDefaults(const {RemoteConfigKeys.debugPassword: ''});

    await fetchAndActivate();
  }

  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      _logAllConfigs();
    } catch (e) {
      // Xử lý lỗi nếu không thể fetch config
      _logger.severe('Remote Config fetch failed: $e');
    }
  }

  void _logAllConfigs() {
    final allConfigs = _remoteConfig.getAll();
    if (allConfigs.isEmpty) {
      _logger.info('No remote configs found or using default values.');
      return;
    }
    _logger.info('Fetched Remote Configs:');
    allConfigs.forEach((key, value) {
      _logger.info(
        '  - $key: ${value.asString()} (Source: ${value.source.name})',
      );
    });
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }
}
