import 'package:monkey_stories/core/constants/shared_pref_keys.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/account/load_update_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountLocalDataSource {
  Future<void> cacheUserInfo(LoadUpdateEntity userInfo);
  Future<int> getUserId();
  Future<PurchasedStatus> getPurchasedInfo();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final SharedPreferences _prefs;

  AccountLocalDataSourceImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  @override
  Future<void> cacheUserInfo(LoadUpdateEntity userInfo) async {
    await _prefs.setInt(SharedPrefKeys.userId, userInfo.user.userId);
    await _prefs.setString(
      SharedPrefKeys.userType,
      userInfo.purchasedInfo.status.value,
    );
  }

  @override
  Future<int> getUserId() async {
    return _prefs.getInt(SharedPrefKeys.userId) ?? 0;
  }

  @override
  Future<PurchasedStatus> getPurchasedInfo() async {
    return PurchasedStatus.fromValue(
      _prefs.getString(SharedPrefKeys.userType) ?? '',
    );
  }
}
