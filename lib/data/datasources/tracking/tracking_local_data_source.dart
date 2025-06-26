import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/datasources/airbridge/airbridge_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/account/account_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/models/tracking/default_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TrackingLocalDataSource {
  Future<DefaultProperties> getDefaultProperties();
  Future<void> listenToAttributionAndCache();
}

class TrackingLocalDataSourceImpl implements TrackingLocalDataSource {
  final ProfileLocalDataSource _profileLocalDataSource;
  final AccountLocalDataSource _accountLocalDataSource;
  final DeviceLocalDataSource _deviceLocalDataSource;
  final SharedPreferences _sharedPreferences;
  final AirbridgeRemoteDataSource _airbridgeRemoteDataSource;

  TrackingLocalDataSourceImpl({
    required ProfileLocalDataSource profileLocalDataSource,
    required AccountLocalDataSource accountLocalDataSource,
    required DeviceLocalDataSource deviceLocalDataSource,
    required SharedPreferences sharedPreferences,
    required AirbridgeRemoteDataSource airbridgeRemoteDataSource,
  }) : _profileLocalDataSource = profileLocalDataSource,
       _accountLocalDataSource = accountLocalDataSource,
       _deviceLocalDataSource = deviceLocalDataSource,
       _sharedPreferences = sharedPreferences,
       _airbridgeRemoteDataSource = airbridgeRemoteDataSource;

  @override
  Future<void> listenToAttributionAndCache() async {
    _airbridgeRemoteDataSource.attributionDataStream.listen((attributionData) {
      final channel = attributionData['attributedChannel'] as String?;
      final campaign = attributionData['attributedCampaign'] as String?;
      if (channel != null) {
        _sharedPreferences.setString(SharedPrefKeys.airbridgeChannel, channel);
      }
      if (campaign != null) {
        _sharedPreferences.setString(
          SharedPrefKeys.airbridgeCampaign,
          campaign,
        );
      }
    });
    _airbridgeRemoteDataSource.listenToAttribution();
  }

  @override
  Future<DefaultProperties> getDefaultProperties() async {
    final currentProfile = await _profileLocalDataSource.getCurrentProfile();
    final currentProfileAge =
        await _profileLocalDataSource.getCurrentProfileAge();
    final userId = await _accountLocalDataSource.getUserId();
    final purchasedInfo = await _accountLocalDataSource.getPurchasedInfo();
    final deviceId = await _deviceLocalDataSource.getDeviceId();
    final deviceInfo = await _deviceLocalDataSource.getDeviceInfo();
    final country = _sharedPreferences.getString(SharedPrefKeys.countryCode);
    final channel = _sharedPreferences.getString(
      SharedPrefKeys.airbridgeChannel,
    );
    final campaign = _sharedPreferences.getString(
      SharedPrefKeys.airbridgeCampaign,
    );

    return DefaultProperties(
      profileId: currentProfile,
      age: currentProfileAge,
      userId: userId,
      userType: purchasedInfo,
      deviceId: int.tryParse(deviceId ?? '0'),
      country: country,
      deviceType: deviceInfo['deviceType'],
      platform: deviceInfo['platform'],
      osName: deviceInfo['osName'],
      osVersion: deviceInfo['osVersion'],
      appVersion: deviceInfo['appVersion'],
      channel: channel ?? 'unattributed',
      campaign: campaign ?? 'unattributed',
    );
  }
}
