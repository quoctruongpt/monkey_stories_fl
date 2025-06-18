import 'package:monkey_stories/core/remote_config/remote_config_service.dart';

abstract class RemoteConfigRemoteDataSource {
  Future<void> initialize();
  String getString(String key);
  bool getBool(String key);
  int getInt(String key);
  double getDouble(String key);
}

class RemoteConfigRemoteDataSourceImpl extends RemoteConfigRemoteDataSource {
  final RemoteConfigService _remoteConfigService;

  RemoteConfigRemoteDataSourceImpl(this._remoteConfigService);

  @override
  Future<void> initialize() async {
    return _remoteConfigService.initialize();
  }

  @override
  String getString(String key) {
    return _remoteConfigService.getString(key);
  }

  @override
  bool getBool(String key) {
    return _remoteConfigService.getBool(key);
  }

  @override
  int getInt(String key) {
    return _remoteConfigService.getInt(key);
  }

  @override
  double getDouble(String key) {
    return _remoteConfigService.getDouble(key);
  }
}
