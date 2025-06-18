import 'package:monkey_stories/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SystemLocalDataSource {
  Future<String> getCountryCode();
  Future<void> cacheCountryCode(String countryCode);
}

class SystemLocalDataSourceImpl implements SystemLocalDataSource {
  final SharedPreferences sharedPreferences;

  SystemLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getCountryCode() async {
    return sharedPreferences.getString(SharedPrefKeys.countryCode) ?? '';
  }

  @override
  Future<void> cacheCountryCode(String countryCode) async {
    await sharedPreferences.setString(SharedPrefKeys.countryCode, countryCode);
  }
}
