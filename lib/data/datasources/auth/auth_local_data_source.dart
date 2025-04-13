import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart'; // Assuming SharedPrefKeys is exported here
import 'package:monkey_stories/core/error/exceptions.dart'; // Cần tạo file này

abstract class AuthLocalDataSource {
  Future<bool> isLoggedIn();
  Future<void> cacheToken(String token); // Ví dụ
  Future<String?> getToken(); // Ví dụ
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isLoggedIn() async {
    final token = sharedPreferences.getString(SharedPrefKeys.token);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(SharedPrefKeys.token, token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(SharedPrefKeys.token);
    } catch (e) {
      throw CacheException();
    }
  }
}
