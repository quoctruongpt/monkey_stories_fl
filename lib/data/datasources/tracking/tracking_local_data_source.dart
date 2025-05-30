import 'package:monkey_stories/data/datasources/account/account_local_data_source.dart';
import 'package:monkey_stories/data/datasources/profile/profile_local_data_source.dart';
import 'package:monkey_stories/data/models/tracking/default_properties.dart';

abstract class TrackingLocalDataSource {
  Future<DefaultProperties> getDefaultProperties();
}

class TrackingLocalDataSourceImpl implements TrackingLocalDataSource {
  final ProfileLocalDataSource _profileLocalDataSource;
  final AccountLocalDataSource _accountLocalDataSource;

  TrackingLocalDataSourceImpl({
    required ProfileLocalDataSource profileLocalDataSource,
    required AccountLocalDataSource accountLocalDataSource,
  }) : _profileLocalDataSource = profileLocalDataSource,
       _accountLocalDataSource = accountLocalDataSource;

  @override
  Future<DefaultProperties> getDefaultProperties() async {
    final currentProfile = await _profileLocalDataSource.getCurrentProfile();
    final currentProfileAge =
        await _profileLocalDataSource.getCurrentProfileAge();
    final userId = await _accountLocalDataSource.getUserId();
    final purchasedInfo = await _accountLocalDataSource.getPurchasedInfo();

    return DefaultProperties(
      profileId: currentProfile,
      age: currentProfileAge,
      userId: userId,
      userType: purchasedInfo,
    );
  }
}
