import 'package:monkey_stories/data/datasources/account/account_local_data_source.dart';
import 'package:monkey_stories/data/datasources/device/device_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/models/tracking/default_properties.dart';

abstract class TrackingLocalDataSource {
  Future<DefaultProperties> getDefaultProperties();
}

class TrackingLocalDataSourceImpl implements TrackingLocalDataSource {
  final ProfileLocalDataSource _profileLocalDataSource;
  final AccountLocalDataSource _accountLocalDataSource;
  final DeviceLocalDataSource _deviceLocalDataSource;

  TrackingLocalDataSourceImpl({
    required ProfileLocalDataSource profileLocalDataSource,
    required AccountLocalDataSource accountLocalDataSource,
    required DeviceLocalDataSource deviceLocalDataSource,
  }) : _profileLocalDataSource = profileLocalDataSource,
       _accountLocalDataSource = accountLocalDataSource,
       _deviceLocalDataSource = deviceLocalDataSource;

  @override
  Future<DefaultProperties> getDefaultProperties() async {
    final currentProfile = await _profileLocalDataSource.getCurrentProfile();
    final currentProfileAge =
        await _profileLocalDataSource.getCurrentProfileAge();
    final userId = await _accountLocalDataSource.getUserId();
    final purchasedInfo = await _accountLocalDataSource.getPurchasedInfo();
    final deviceId = await _deviceLocalDataSource.getDeviceId();

    return DefaultProperties(
      profileId: currentProfile,
      age: currentProfileAge,
      userId: userId,
      userType: purchasedInfo,
      deviceId: int.parse(deviceId ?? '0'),
    );
  }
}
